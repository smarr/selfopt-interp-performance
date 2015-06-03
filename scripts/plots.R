## Warmup Plot
warmup_plot <- function (data, title, group = "VM") {
  upperBound <- 2 * median(data$Value)
  data <- ddply(data, ~ Benchmark, here(transform),
                ValCut = pmin(Value, upperBound))
  
  plot <- ggplot(data, aes_string(x="Iteration", y="ValCut"))
  plot <- plot + geom_line(aes_string(colour = group))
  plot <- plot + ggtitle(title)
  plot <- plot + theme_simple()
  plot
}


## Theme settings

theme_simple <- function() {
    theme_bw() +
    theme(axis.text.x          = element_text(size = 8, lineheight=0.7),
          axis.title.x         = element_blank(),
          axis.title.y         = element_text(size = 8),
          axis.text.y          = element_text(size = 8),
          axis.line            = element_line(colour = "gray"),
          plot.title           = element_text(size = 8),
          panel.background     = element_blank(), #element_rect(fill = NA, colour = NA),
          panel.grid.major     = element_blank(),
          panel.grid.minor     = element_blank(),
          panel.border         = element_blank(),
          plot.background      = element_blank(), #element_rect(fill = NA, colour = NA)
          strip.background     = element_blank(),
          plot.margin = unit(c(0,0,0,0), "cm")) 
}
