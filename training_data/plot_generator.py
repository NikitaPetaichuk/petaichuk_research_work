from datetime import datetime
import os

import matplotlib.pyplot as plt


def draw_plot(plot_file_path, plot_title, x_values, y_values, x_label, y_label):
    figure, ax = plt.subplots(figsize=(25, 7.5))
    ax.plot(x_values, y_values)
    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)
    ax.set_title(plot_title)
    figure.savefig(plot_file_path)
    plt.close(figure)


def create_plot_from_txt_file(txt_file_path, plot_file_path):
    timestamps, values = [], []
    plot_title = txt_file_path.split('\\')[-1]
    with open(txt_file_path, "r") as txt_file:
        for line in txt_file:
            timestamp, value = line.strip().split(";")
            timestamp = datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S")
            value = float(value)
            timestamps.append(timestamp)
            values.append(value)
    draw_plot(plot_file_path, plot_title, timestamps, values, "Time", "Counts/s")


def main():
    for address, _, file_names in os.walk('txt'):
        if len(file_names) != 0:
            for file_name in file_names:
                file_path = os.path.join(address, file_name)
                picture_file_path = file_path.replace('txt', 'png')
                create_plot_from_txt_file(file_path, picture_file_path)


if __name__ == '__main__':
    main()
