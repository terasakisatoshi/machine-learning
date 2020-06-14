# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.5.0
#   kernelspec:
#     display_name: Python 3
#     language: python
#     name: python3
# ---

# # Loading an example dataset
#
# - `scikit-learn` comes with a few standard datasets, for instance the `iris` and `digits` datasets for classification and the `diabetes dataset` for regression.
#
# - In the following, we start a Python interpreter from our shell and then load the `iris` and `digits` datasets.

from sklearn import datasets
iris = datasets.load_iris()
digits = datasets.load_digits()

from sklearn import svm
clf = svm.SVC(gamma=0.001, C=100.)

clf.fit(digits.data[:-1], digits.target[:-1])

clf.predict(digits.data[-1:])

# +
import numpy as np
from sklearn import random_projection

rng = np.random.RandomState(0)
X = rng.rand(10, 2000)
X = np.array(X, dtype=np.float32)
X.dtype
# -

transformer = random_projection.GaussianRandomProjection()
X_new = transformer.fit_transform(X)
X_new.dtype

from sklearn import datasets
from sklearn.svm import SVC
iris = datasets.load_iris()
clf = SVC()
clf.fit(iris.data, iris.target)
list(clf.predict(iris.data[:3]))
clf.fit(iris.data, iris.target_names[iris.target])
SVC()
list(clf.predict(iris.data[:3]))

import numpy as np
from sklearn.datasets import load_iris
from sklearn.svm import SVC
X, y = load_iris(return_X_y=True)
clf = SVC()

clf.set_params(kernel='linear').fit(X, y)
clf.predict(X[:5])
clf.set_params(kernel="rbf").fit(X, y)
clf.predict(X[:5])

from sklearn.svm import SVC
from sklearn.multiclass import OneVsRestClassifier
from sklearn.preprocessing import LabelBinarizer
clf = OneVsRestClassifier(estimator=SVC(random_state=0))
clf.fit(X,y).predict(X)

y = LabelBinarizer().fit_transform(y)
clf.fit(X, y).predict(X)


