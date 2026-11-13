library(ggplot2)

df <- data.frame(
  x = c(1, 2, 3, 4, 5),
  y = c(1.1, 1.9, 3.2, 3.8, 5.1)
)

p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(size = 3, color = "#3366CC") +
  geom_smooth(method = "lm", se = FALSE, color = "#CC3333") +
  ggtitle("ggplot2 example in a container")

ggsave("ggplot2_plot.png", plot = p, width = 7, height = 5, dpi = 150)

cat("Saved ggplot2_plot.png\n")
