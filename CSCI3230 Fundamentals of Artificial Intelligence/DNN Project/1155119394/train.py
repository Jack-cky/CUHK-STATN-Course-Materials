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
# from sklearn.metrics import balanced_accuracy_score

# function for reading Explanatory Variables (EV)
def data_x(path):
    return pickle.load(open(path, 'rb'))['onehots']

# function for reading Response Variable (RV)
def data_y(path):
    labels = []
    with open(path) as data:
        lines = data.readlines()
    for i in range(len(lines)):
        if lines[i].rsplit(',')[1][:1] == '0':
            labels.append([1, 0])
        else:
            labels.append([0, 1])
    return np.array(labels)

# function for loading EV and RV
def load_data(x_path, y_path):
    return data_x(x_path), data_y(y_path)

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

# function to randomly select testing data by batch_size
def next_batch(batch_size, x, y):
    positive_index = np.where(y == [1, 0])[0]
    positive_index = np.unique(positive_index)
    # here we introduce randomization to deal with imbalanced data
    positive_size = np.random.binomial(batch_size, 0.5)
    positive_index = np.random.choice(positive_index, size = positive_size, replace = False)

    negative_index = np.where(y == [0, 1])[0]
    negative_index = np.unique(negative_index)
    negative_size = batch_size - positive_size
    negative_index = np.random.choice(negative_index, size = negative_size, replace = False)
    
    index = np.append(positive_index, negative_index)
    np.random.shuffle(index)

    return np.asarray(x[index]), np.asarray(y[index])

# function to train the model
def train(x, y, keep_prob, epochs, batch_size, tol):
    dnn = model(x)
    y_hat = tf.argmax(dnn, axis = 1)
    y_str = tf.argmax(y, axis = 1)
    
    cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits_v2(labels = y, logits = dnn))
    optimiser = tf.train.AdamOptimizer(tol).minimize(cost)
    
    correct = tf.equal(y_hat, y_str)
    accuracy = tf.reduce_mean(tf.cast(correct, tf.float32))
    
    sess = tf.InteractiveSession()
    sess.run(tf.global_variables_initializer())

    for i in range(epochs):
        for j in range(round(n / batch_size)):
            x_batch, y_batch = next_batch(batch_size, x_train, y_train)
            _ = sess.run([optimiser], feed_dict = {x: x_batch, y: y_batch, keep_prob: 0.6})
        train_accuracy = sess.run([accuracy], feed_dict = {x: x_batch, y: y_batch, keep_prob: 1})
        print("Epochs %d: training accuracy %g" % (i + 1, train_accuracy[0]))

    # y_str_ = sess.run(y_str, feed_dict = {y: y_test, keep_prob: 1})
    # y_hat_ = sess.run(y_hat, feed_dict = {x: x_test, keep_prob: 1})
    # print("Balanced Accuracy is {:.4f}".format(balanced_accuracy_score(y_str_, y_hat_)))

    saver = tf.train.Saver()
    saver.save(sess, './dnn_model', global_step = 1)

# define data source path
train_y_path = './data/SR-ARE-train/names_labels.txt'
train_x_path = './data/SR-ARE-train/names_onehots.pickle'

test_y_path = './data/SR-ARE-test/names_labels.txt'
test_x_path = './data/SR-ARE-test/names_onehots.pickle'

# load data
x_train, y_train = load_data(train_x_path, train_y_path)
x_test, y_test = load_data(test_x_path, test_y_path)

# utilise both test data and train data to fit the model
x_train = np.append(x_train, x_test, axis = 0)
y_train = np.append(y_train, y_test, axis = 0)

# define basic model parameters
nrow = x_train.shape[1]
ncol = x_train.shape[2]
n_labels = y_train.shape[1]
n = len(y_train)
epochs = 40
batch_size = 128
tol = 1e-4

# initalise tensorflow variables
x = tf.placeholder(tf.float32, shape = [None, nrow, ncol])
y = tf.placeholder(tf.float32, shape = [None, n_labels])
keep_prob = tf.placeholder(tf.float32)

# train the model
train(x, y, keep_prob, epochs, batch_size, tol)

'''
Reference:
    1. http://tensorflow.biotecan.com/python/Python_1.8/tensorflow.google.cn/api_docs/python/tf/layers/Conv2D.html
    2. https://blog.csdn.net/HappyRocking/article/details/80243790
    3. https://github.com/aymericdamien/TensorFlow-Examples/blob/master/examples/3_NeuralNetworks/convolutional_network.py
    4. https://www.tensorflow.org/api_docs/python/tf/keras/layers/Conv2D
    5. https://arbu00.blogspot.com/2017/03/2-tensorflowconvolutional-neural.html
'''