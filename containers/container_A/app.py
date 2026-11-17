import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns


df = pd.DataFrame(
    {
        "x": [1, 2, 3, 4, 5, 6],
        "y": [1.1, 1.9, 3.2, 3.8, 5.0, 5.9],
        "group": ["A", "A", "B", "B", "A", "B"],
    }
)
ax = sns.scatterplot(data=df, x="x", y="y", hue="group")
ax.set_title("Seaborn example in a container")
plt.tight_layout()
plt.savefig("seaborn_plot.png", dpi=150)

print("Saved seaborn_plot.png")
