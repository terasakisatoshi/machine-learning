import pathlib
from typing import List

from PIL import Image
import streamlit as st
from tensorflow import keras


@st.cache
def download() -> str:
    data_dir = keras.utils.get_file(
        origin="https://storage.googleapis.com/download.tensorflow.org/example_images/flower_photos.tgz",
        fname="flower_photos",
        untar=True,
    )
    return data_dir


class FlowerDataset:
    def __init__(self):
        self.data_dir = pathlib.Path(download())
        self.labels = ["sunflowers", "daisy", "roses", "tulips", "dandelion"]

    def select(self, label: str) -> List[pathlib.Path]:
        return list(self.data_dir.glob(f"{label}/*"))


def main():
    st.markdown("# Data visualization tool using Streamlit")
    dataset = FlowerDataset()
    selector = st.sidebar.selectbox("Select your favorite flower", dataset.labels)
    selected_data = dataset.select(selector)
    index = st.sidebar.number_input(
        f"Select index from 0 to {len(selected_data)}",
        min_value=0,
        max_value=len(selected_data),
        value=0,
        step=1,
    )
    sample_path = selected_data[index]
    image = Image.open(sample_path)
    expand = st.sidebar.checkbox("Expand")
    degree = st.sidebar.slider("Degree", min_value=0, max_value=180, step=1)
    st.image(image.rotate(degree, expand=expand))


if __name__ == "__main__":
    main()
