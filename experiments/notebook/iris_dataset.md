---
jupyter:
  jupytext:
    formats: md,ipynb
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.8.0
  kernelspec:
    display_name: Python 3
    language: python
    name: python3
---

# iris dataset の 相関を見る

```python
from matplotlib import pyplot as plt
import numpy as np
from sklearn import datasets
```

```python
import ipywidgets as widgets
```

```python
iris = datasets.load_iris()

options = {n:i for (i, n) in enumerate(iris.feature_names)}

d1 = widgets.Dropdown(
    options=options,
    value=0,
    description='f1:',
    disabled=False,
)

d2 = widgets.Dropdown(
    options=options,
    value=1,
    description='f2:',
    disabled=False,
)

def scatter_plot(f1, f2):
    feature_indices=list(range(len(iris.feature_names)))
    f1name, f2name = iris.feature_names[f1], iris.feature_names[f2]
    for class_number in np.unique(iris.target):
        indices, *_ = np.where(iris.target == class_number)
        plt.scatter(
            iris.data[indices, feature_indices[f1]], 
            iris.data[indices, feature_indices[f2]], 
            label=iris.target_names[class_number],
        )

    plt.xlabel(f1name)
    plt.ylabel(f2name)
    plt.legend()
    
widgets.interact(scatter_plot, f1=d1, f2=d2)
```
