from skimage import io, transform
import torch
from torch.autograd import Variable
import torch.nn as nn
from torch.utils.data import DataLoader
from torchvision import transforms
import torch.optim as optim
from PIL import Image
import numpy as np
import cv2
import glob
from threading import Thread
import time

from model import U2NET 

from flask import Flask, flash, request, redirect, url_for, render_template, Response, send_file, url_for
import urllib.request
import os
from werkzeug.utils import secure_filename

from data_loader import RescaleT, RandomCrop, ToTensorLab, SalObjDataset

import jsonpickle
from matplotlib import pyplot as plt
import tempfile
 
def normPRED(d):
    ma = torch.max(d)
    mi = torch.min(d)

    dn = (d-mi)/(ma-mi)

    return dn

def save_output(image_name,output_name,pred,d_dir,type):

    predict = pred
    predict = predict.squeeze()
    predict_np = predict.cpu().data.numpy()

    im = Image.fromarray(predict_np*255).convert('RGB')
    
    image = io.imread(image_name)
    imo = im.resize((image.shape[1],image.shape[0]))

    pb_np = np.array(imo)
    
    if type=='image':
    # Make and apply mask
        mask = pb_np[:,:,0]
        mask = np.expand_dims(mask, axis=2)
        imo = np.concatenate((image,mask),axis = 2)
        imo = Image.fromarray(imo, 'RGBA') 
    
    imo.save(d_dir+output_name)
    
def next_name(dir):
    images = []
    names = []
    for image in os.listdir(dir):
        images.append(image)
    for img_name in images:    
        aaa = img_name.split(".")
        names.append(int(aaa[0]))
    if len(names)==1:
        return str(names[0]+1)
    return str(names[-1]+1)

def temp_name():
    tf = tempfile.NamedTemporaryFile(prefix='im',delete=True)
    name = tf.name
    tf.close
    return name

    
here = os.path.dirname(__file__)
input_dir = os.path.join(here, 'static/uploads/')
prediction_dir = os.path.join(here,'static/uploads/')
model_name='u2net'

#--------------------------------------------------### Training ###--------------------------------------------------------


# ------- 1. define loss function --------

bce_loss = nn.BCELoss(size_average=True)

def muti_bce_loss_fusion(d0, d1, d2, d3, d4, d5, d6, labels_v):

	loss0 = bce_loss(d0,labels_v)
	loss1 = bce_loss(d1,labels_v)
	loss2 = bce_loss(d2,labels_v)
	loss3 = bce_loss(d3,labels_v)
	loss4 = bce_loss(d4,labels_v)
	loss5 = bce_loss(d5,labels_v)
	loss6 = bce_loss(d6,labels_v)

	loss = loss0 + loss1 + loss2 + loss3 + loss4 + loss5 + loss6
	print("l0: %3f, l1: %3f, l2: %3f, l3: %3f, l4: %3f, l5: %3f, l6: %3f\n"%(loss0.data.item(),loss1.data.item(),loss2.data.item(),loss3.data.item(),loss4.data.item(),loss5.data.item(),loss6.data.item()))

	return loss0, loss



# ------- 2. define model --------

# model_dir = os.path.join(os.getcwd(), 'saved_models', model_name+'_human_seg', model_name + '_human_seg.pth')
model_dir = os.path.join(here, 'saved_models', model_name, model_name + '.pth')

net = U2NET(3,1)        

if torch.cuda.is_available():
    net.load_state_dict(torch.load(model_dir))
    net.cuda()
else:
    net.load_state_dict(torch.load(model_dir, map_location='cpu'))
net.eval()

# ------- 3. define optimizer --------
print("---define optimizer...")
optimizer = optim.Adam(net.parameters(), lr=0.001, betas=(0.9, 0.999), eps=1e-08, weight_decay=0)


# Initialize the Flask application
app = Flask(__name__)
app.secret_key = "secret key"
train_result = ""

@app.route('/api/save_image', methods=['POST'])
def save():
    
    tr_inputs_dir = os.path.join(here,'data/train/inputs/')
    masks_dir = os.path.join(here,'data/train/masks/')
    r = request
    # convert string of image data to uint8
    nparr = np.frombuffer(r.data, np.uint8)

    # decode image
     try:
        img = cv2.imdecode(nparr, cv2.IMREAD_UNCHANGED)
    except:
        # build a response dict to send back to client
        response = {'Message':'Empty image'}
        response_pickled = jsonpickle.encode(response)
        return Response(response=response_pickled, status=200, mimetype="application/json")
     
    # save image to inputs
    # image_name = next_name(inputs_dir)
    print(img[:,:,:3].shape)
    image_name = request.headers.get('name')
    cv2.imwrite(tr_inputs_dir+image_name+'.jpg', img[:,:,:3])
    cv2.imwrite(masks_dir+image_name+'.png', img[:,:,3]) 
   
    #print('upload_image filename: ' + filename)
    flash('Image successfully uploaded and displayed below')
    
    # build a response dict to send back to client
    response = {'message': 'image received. size={}x{}'.format(img.shape[1], img.shape[0])
                }
    # encode response using jsonpickle
    response_pickled = jsonpickle.encode(response)

    return Response(response=response_pickled, status=200, mimetype="application/json")

    
# route http posts to this method
@app.route('/api/removeBg', methods=['POST'])
def test():
    
    inputs_dir = os.path.join(here,'static/inputs/')
    results_dir = os.path.join(here,'static/results/')
    masks_dir = os.path.join(here,'static/masks/')
    
    r = request
    # convert string of image data to uint8
    nparr = np.frombuffer(r.data, np.uint8)
    
    if len(nparr)==0:
        return 'Empty image'
    
    # decode image
    try:
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    except:
        # build a response dict to send back to client
        response = {'Message':'Empty image'}
        response_pickled = jsonpickle.encode(response)
        return Response(response=response_pickled, status=200, mimetype="application/json")
    
    # save image to inputs
    image_name = temp_name().split('/')[-1]    
    cv2.imwrite(inputs_dir+image_name+'.jpg', img)
    
    # processing
    image = transform.resize(img,(320,320),mode='constant')

    tmpImg = np.zeros((image.shape[0],image.shape[1],3))

    tmpImg[:,:,0] = (image[:,:,0]-0.485)/0.229
    tmpImg[:,:,1] = (image[:,:,1]-0.456)/0.224
    tmpImg[:,:,2] = (image[:,:,2]-0.406)/0.225

    tmpImg = tmpImg.transpose((2, 0, 1))
    tmpImg = np.expand_dims(tmpImg, 0)
    image = torch.from_numpy(tmpImg)

    image = image.type(torch.FloatTensor)
    image = Variable(image)

    d1,d2,d3,d4,d5,d6,d7= net(image)
    pred = d1[:,0,:,:]
    pred = normPRED(pred)

    save_output(inputs_dir+image_name+'.jpg',image_name+'.png',pred,results_dir,'image')
    save_output(inputs_dir+image_name+'.jpg',image_name+'.png',pred,masks_dir,'mask')
    
    #print('upload_image filename: ' + filename)
    flash('Image successfully uploaded and displayed below')
    
    # build a response dict to send back to client
    response = {'Message':'Success',
                'input': url_for('static',filename = 'inputs/'+image_name+'.jpg'),
                'result': url_for('static',filename = 'results/'+image_name+'.png'),
                'mask': url_for('static',filename = 'masks/'+image_name+'.png')
                }
    # encode response using jsonpickle
    response_pickled = jsonpickle.encode(response)

    return Response(response=response_pickled, status=200, mimetype="application/json")
    # return redirect(url_for('static',filename = image_name+'.png'), code=301)


@app.route('/api/train')

def training():

    def train(epoch_num = 10, batch_size_train = 12):
        print("---start training...")
        
        ite_num = 0
        running_loss = 0.0
        running_tar_loss = 0.0
        ite_num4val = 0
        save_frq = 5 # save the model every 2000 iterations

        
        # ------- 2. set the directory of training dataset --------

        tra_image_dir = 'data/train/inputs/'
        tra_label_dir = 'data/train/masks/'  

        image_ext = '.jpg'
        label_ext = '.png'

        model_dir = os.path.join(os.getcwd(), 'saved_models', model_name + os.sep+'trained'+ os.sep)
        timestr = time.strftime("%Y%m%d-%H%M%S")
        global train_result
        train_result = "Training in progress.."
        with open(model_dir +'training_results.txt', 'w') as f:
            f.write(train_result)
            f.close()
        # epoch_num = 10 # to change
        # batch_size_train = 10
        batch_size_val = 1
        train_num = 0
        val_num = 0

        tra_img_name_list = glob.glob(tra_image_dir + '*' + image_ext)

        tra_lbl_name_list = []
        for img_path in tra_img_name_list:
            img_name = img_path.split(os.sep)[-1]

            aaa = img_name.split(".")
            bbb = aaa[0:-1]
            imidx = bbb[0]
            for i in range(1,len(bbb)):
                imidx = imidx + "." + bbb[i]

            tra_lbl_name_list.append(tra_label_dir + imidx + label_ext)
        with open(model_dir + timestr+'-results.txt', 'a') as f:
            f.write("---")
            f.write("\n")
            f.write("train images: "+ str(len(tra_img_name_list)))
            f.write("\n")
            f.write("train labels: "+ str(len(tra_lbl_name_list)))
            f.write("\n")
            f.write("---")
            f.write("\n")
            f.close()

        if len(tra_img_name_list)!=len(tra_lbl_name_list):
            train_result = "Fail/Images and masks are not the same amount" 
            with open(model_dir +'training_results.txt', 'w') as f:
                f.write(train_result)
                f.close()
            return 'Training failed'
        if len(tra_img_name_list)==0:
            train_result = "Fail/No train images found" 
            with open(model_dir +'training_results.txt', 'w') as f:
                f.write(train_result)
                f.close()
            return 'Training failed'
        
        train_num = len(tra_img_name_list)

        salobj_dataset = SalObjDataset(
            img_name_list=tra_img_name_list,
            lbl_name_list=tra_lbl_name_list,
            transform=transforms.Compose([
                RescaleT(320),
                RandomCrop(288),
                ToTensorLab(flag=0)]))
        salobj_dataloader = DataLoader(salobj_dataset, batch_size=batch_size_train, shuffle=True, num_workers=1)
        
        try:
            for epoch in range(0, epoch_num):
                net.train()

                for i, data in enumerate(salobj_dataloader):
                    ite_num = ite_num + 1
                    ite_num4val = ite_num4val + 1

                    inputs, labels = data['image'], data['label']

                    inputs = inputs.type(torch.FloatTensor)
                    labels = labels.type(torch.FloatTensor)

                    # wrap them in Variable
                    if torch.cuda.is_available():
                        inputs_v, labels_v = Variable(inputs.cuda(), requires_grad=False), Variable(labels.cuda(),
                                                                                                    requires_grad=False)
                    else:
                        inputs_v, labels_v = Variable(inputs, requires_grad=False), Variable(labels, requires_grad=False)

                    # y zero the parameter gradients
                    optimizer.zero_grad()

                    # forward + backward + optimize
                    d0, d1, d2, d3, d4, d5, d6 = net(inputs_v)
                    loss2, loss = muti_bce_loss_fusion(d0, d1, d2, d3, d4, d5, d6, labels_v)

                    loss.backward()
                    optimizer.step()

                    # # print statistics
                    running_loss += loss.data.item()
                    running_tar_loss += loss2.data.item()

                    # del temporary outputs and loss
                    del d0, d1, d2, d3, d4, d5, d6, loss2, loss

                    line = ("[epoch: %3d/%3d, batch: %5d/%5d, ite: %d] train loss: %3f, tar: %3f " % (
                    epoch + 1, epoch_num, (i + 1) * batch_size_train, train_num, ite_num, running_loss / ite_num4val, running_tar_loss / ite_num4val))
                    train_result = line
                    with open(model_dir +'training_results.txt', 'w') as f:
                        f.write(train_result)
                    print(line)
                    with open(model_dir + timestr+'-results.txt', 'a') as f:
                        f.write(timestr+'-')
                        f.write(line)
                        f.write('\n')
                        f.close()
                        
                    if ite_num % save_frq == 0:

                        torch.save(net.state_dict(), model_dir + model_name+ timestr+ "_bce_itr_%d_train_%3f_tar_%3f.pth" % (ite_num, running_loss / ite_num4val, running_tar_loss / ite_num4val))
                        loss_value = running_loss / ite_num4val
                        running_loss = 0.0
                        running_tar_loss = 0.0
                        net.train()  # resume train
                        ite_num4val = 0
        except:
            train_result = "Fail/Training error" 
            with open(model_dir +'training_results.txt', 'w') as f:
                f.write(train_result)
            return 'Training failed'
        
        train_result = "Success/ train loss = " + str(loss_value)
        with open(model_dir +'training_results.txt', 'w') as f:
            f.write(train_result)
        return 'Training successful'
    
    r = request    
    epochs = request.headers.get('epochs')
    batch_size = request.headers.get('batch_size')
    
    try:
        epochs = int(epochs)
    except:
        epochs = 5
    try:
        batch_size = int(batch_size)
    except:
        batch_size = 10
    
    thread = Thread(target=train,args=(epochs,batch_size))
    thread.start()
    response = {'Message':'Train started'
                    }
    # encode response using jsonpickle
    response_pickled = jsonpickle.encode(response)

    return Response(response=response_pickled, status=200, mimetype="application/json")

@app.route('/api/trainResult')    
def trainResult():
    model_dir = os.path.join(os.getcwd(), 'saved_models', model_name + os.sep+'trained'+ os.sep)
    with open(model_dir +'training_results.txt', 'r') as f:
            train_result = f.readline()
    response = {'Message':train_result}
    # encode response using jsonpickle
    response_pickled = jsonpickle.encode(response)

    return Response(response=response_pickled, status=200, mimetype="application/json")



# start flask app
if __name__=="__main__" : app.run()
