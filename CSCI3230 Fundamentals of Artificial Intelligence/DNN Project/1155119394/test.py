'''
CSCI3230 Neural Network Project

Declaration:
I declare that the assignment here submitted is original
except for source material explicitly acknowledged,
and that the same or closely related material has not been
previously submitted for another course.
I also acknowledge that I am aware of University policy and
regulations on honesty in academic work, and of the disciplinary
guidelines and procedures applicable to breaches of such
policy and regulations, as contained in the website.
 
University Guideline on Academic Honesty:
http://www.cuhk.edu.hk/policy/academichonesty
Faculty of Engineering Guidelines to Academic Honesty:
https://www.erg.cuhk.edu.hk/erg/AcademicHonesty

Student Name: CHAN KING YEUNG
Student ID: 1155119394
Date: 15/11/2020
'''
# import libraries
import tensorflow as tf
import numpy as np
import pickle

# function for reading Explanatory Variables (EV)
def data_x(path):
    return pickle.load(open(path, 'rb'))['onehots']

# function to define CNN (using layers.Conv2D API)
def model(x):
    # reshape to match SMILES expression
    nn = tf.reshape(x, shape = [-1, nrow, ncol, 1])
    # define 2 convolutional layers and maximum pooling
    conv1 = tf.layers.conv2d(nn, 16, 5, activation = tf.nn.relu, padding = 'SAME', kernel_initializer = tf.truncated_normal_initializer(), bias_initializer = tf.constant_initializer(0.1))
    pool1 = tf.layers.max_pooling2d(conv1, 5, 5)
    conv2 = tf.layers.conv2d(pool1, 32, 2, activation = tf.nn.relu, padding = 'SAME', kernel_initializer = tf.truncated_normal_initializer(), bias_initializer = tf.constant_initializer(0.01))
    pool2 = tf.layers.max_pooling2d(conv2, 2, 2)
    flat = tf.contrib.layers.flatten(pool2)
    # define 3 fully connected layers
    fc1 = tf.layers.dense(flat, 64, activation = tf.nn.leaky_relu, kernel_initializer = tf.truncated_normal_initializer(), bias_initializer = tf.constant_initializer(0.1))
    fc1 = tf.layers.dropout(fc1, rate = 1 - keep_prob)
    fc2 = tf.layers.dense(fc1, 128, activation = tf.nn.leaky_relu, kernel_initializer = tf.truncated_normal_initializer(), bias_initializer = tf.constant_initializer(0.01))
    fc2 = tf.layers.dropout(fc2, rate = 1 - keep_prob)
    fc3 = tf.layers.dense(fc2, 256, activation = tf.nn.leaky_relu, kernel_initializer = tf.truncated_normal_initializer(), bias_initializer = tf.constant_initializer(0.001))
    fc3 = tf.layers.dropout(fc3, rate = 1 - keep_prob)
    return tf.layers.dense(fc3, n_labels)

# function to test the model
def test():
    dnn = model(x)
    y_hat = tf.argmax(dnn, axis = 1)

    sess = tf.InteractiveSession()
    sess.run(tf.global_variables_initializer())

    saver = tf.train.Saver()
    ckpt = tf.train.get_checkpoint_state('.')
    if ckpt and ckpt.model_checkpoint_path:
        saver.restore(sess, ckpt.model_checkpoint_path)
    
    y_hat_ = sess.run(y_hat, feed_dict = {x: x_test, keep_prob: 1})

    f = open('labels.txt', 'w')
    for i in range(len(y_hat_)):
        if y_hat_[i] == 0:
            f.write('0\n')
        else:
            f.write('1\n')
    f.close()

# define data source path
test_x_path = '../SR-ARE-score/names_onehots.pickle'

# test_y_path = './data/SR-ARE-test/names_labels.txt'
# test_x_path = './data/SR-ARE-test/names_onehots.pickle'

# load data
x_test = data_x(test_x_path)

# define basic model parameters
nrow = 70
ncol = 325
n_labels = 2
n = 7401
epochs = 40
batch_size = 128
tol = 1e-4

# initalise tensorflow variables
x = tf.placeholder(tf.float32, shape = [None, nrow, ncol])
y = tf.placeholder(tf.float32, shape = [None, n_labels])
keep_prob = tf.placeholder(tf.float32)

# test the model
test()