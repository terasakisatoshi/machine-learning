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

# # Getting Started
#
# - The purpose of this guide is to illustrate some of the main features that `scikit-learn` provides.
# - It assumes a very basic working knowledge of machine learning practices (e.g. model fitting, predicting, cross-validation, etc.).
#
# - `scikit-learn` is an open source machine learning library that supports supervised and unsupervised learning. It also provides various tools for model fitting, data preprocessing, model selection and evaluation, and many other utilities.

# # Fitting and predicting: estimator basics
#
# - `scikit-learn` provides dozens of built-in machine learning algorithms and models, called `estimators`. Each estimator can be fitted to some data using its `fit` method.
#
# - Here is a simple example where we fit a `RandomForestClassifier` to some very basic data:

# +
from sklearn.ensemble import RandomForestClassifier

classifier = RandomForestClassifier(random_state=0)
# define mock sample 2 samples with 3 features
X = [
    [1,2,3],
    [11,12,13],
]

# classes of each sample
y = [0, 1]

classifier.fit(X, y)
# -

classifier.predict(X)
classifier.predict([
    [4,5,6],
    [14,15,16],
])

# # Machine Learning workflows are often compised of different parts
#
# - A typical pipeline consists of a preprocessing step that transforms or imputes the data, and a final predictor that predicts target values.
#
# - In `scikit-learn`, pre-processors and transformers follow the same API as the estimator objects (they actually all inherit from the same `BaseEstimator` class)
# - The transformer objects don't have a predict method but rather a `transform` method that outputs a newly transformed sample matrix `X`

# +
from sklearn.preprocessing import StandardScaler

# take mean along with axis=0
X = [
    [0, 15, 3],
    [1, -10, 2],
]

tfm = StandardScaler(with_std=False)
out = tfm.fit(X).transform([[2,2,2]])
print(tfm.mean_)

assert (out == [2 - 0.5, 2 - 2.5, 2 - 2.5]).all()
# -

# - Sometimes, you want to apply different transformations to different features: the `ColumnTransformer` is designed for these use-cases.

# # Pipelines: chaining pre-processors and estimators
#
# - Transformers and estimators (predictors) can be combined together into a single unifying object: a `Pipeline`. The pipeline offers the same API as a regular estimator: it can be fitted and used for prediction with `fit` and `predict`. As we will see later, using a pipeline will also prevent you from data leakage, i.e. disclosing some testing data in your training data.

from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# +
pipe = make_pipeline(
    StandardScaler(),
    LogisticRegression(random_state=0),
)

X, y = load_iris(return_X_y=True,as_frame=True)

X_train, X_test, y_train, y_test= train_test_split(
    X, y, 
    random_state=0
)

pipe.fit(X_train, y_train)
accuracy_score(pipe.predict(X_test), y_test)
# -

# # Model evaluation
#
# - Fitting a model to some data does not entail that will predict well on unseed data. This needs to be directory evaluated. We have just seen the `train_test_split` helper that splits a dataset into train and teset sets, but `scikit-learn` provides many other tools for model evaluation, in particular for `cross-validation`.
#
# - We here briefly show how to perform a 5-fold cross-validation procedure, using the `cross_validate` helper. Note that it is also possible to manually iterate over the folds, use different data splitting strategie, and use custom scoring functions. Please refer to our User Guide for more details:

from sklearn.datasets import make_regression
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_validate

X, y = make_regression(n_samples=5000, random_state=0)
lr = LinearRegression()
result = cross_validate(lr,X,y,cv=5) # defaults to 5-fold
result["test_score"]

from sklearn.datasets import fetch_california_housing
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import RandomizedSearchCV
from sklearn.model_selection import train_test_split
from scipy.stats import randint

X, y = fetch_california_housing(return_X_y=True)
X_train, X_test, y_train,y_test = train_test_split(X, y, random_state=0)

# +
param_distributions = {
    "n_estimators": randint(1,5),
    "max_depth": randint(5,10),
}

search = RandomizedSearchCV(
    estimator=RandomForestRegressor(random_state=0),
    n_iter=5,
    param_distributions=param_distributions,
    random_state=0,
)

search.fit(X_train, y_train)
print(search.best_params_)
search.score(X_test, y_test)
