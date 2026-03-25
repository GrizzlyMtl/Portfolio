cat("🧩 Assembling dashboard layout...\n")

# Assemble all visual panels
dashboard <- (p1 | p2) / (p3 | p4)

cat("🖼️ Adding global title and annotations...\n")

# Add global title and styling
dashboard_final <- dashboard +
  plot_annotation(
    title    = "SALES DASHBOARD – COMPLETE ANALYSIS",
    subtitle = "Overview of Commercial Performance",
    caption  = "Source: Internal Data | Period: 2023–2024",
    theme    = theme(
      plot.title    = element_text(size = 18, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 14, hjust = 0.5),
      plot.caption  = element_text(size = 10, color = "gray70")
    )
  )

cat("💾 Saving dashboard to file: 'sales_dashboard_final.png'\n")

# Save dashboard to file
ggsave("sales_dashboard_final.png", dashboard_final, width = 16, height = 10, dpi = 300, bg = "white")

cat("✅ Dashboard saved and ready for display.\n\n")

# Display in viewer
print(dashboard_final)
