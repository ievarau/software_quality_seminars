# Software Quality Meeting (Thursday November 21th)

See the IPYNB file for code and visualization. **Interactive figures require a running kernel with appropriate dependencies to be displayed.**

You can install dependencies using the following commands:

```bash
# Tested on Python 3.13.2
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt

# Then, use this virtual env as the kernel for the notebook.
```

This presentation provides a practical guide to choosing the right Python plotting library for different data visualization tasks. Rather than teaching how to use each library, it focuses on when to use them, organizing libraries into categories:
- Publication Standards: Matplotlib (low-level control for publication polishing), Seaborn (statistical plots and cluster maps), and Plotnine (Grammar of Graphics for R users)
- Interactive & Web: Plotly (HTML/JS plots for exploration) and Altair (linked interactive visualizations)
- Specialized Tools: UpSetPlot (complex set intersections), Yellowbrick (ML model diagnostics), Statannotations (automated p-value annotations), and YData Profiling (automated exploratory data analysis)
- Big Data & Genomics: Datashader (rendering millions of data points) and PyGenomeTracks (genomic track visualization)

The presentation emphasizes matching the tool to the context—using imperative approaches for fine control, declarative syntax for rapid statistical visualization, and specialized libraries for domain-specific challenges like single-cell RNA-seq or machine learning diagnostics. It's designed for a Software Quality Meeting audience and accompanies a Jupyter Notebook with code examples.
