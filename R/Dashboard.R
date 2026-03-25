tryCatch({
  # Chargement des librairies
  library(dplyr)
  library(ggplot2)
  library(zoo)
  library(patchwork)
  library(scales)
  
  # Simulation des données
  set.seed(123)
  ventes_ecommerce <- data.frame(
    date = rep(seq.Date(from = as.Date("2024-01-01"), to = as.Date("2024-12-31"), by = "day"), 4),
    canal = rep(c("Web", "Mobile", "App", "Social"), each = 366),
    ventes = c(
      rnorm(366, mean = 1000, sd = 200) + sin(1:366 * 2 * pi / 365) * 300,
      rnorm(366, mean = 800, sd = 150) + sin(1:366 * 2 * pi / 365) * 200,
      rnorm(366, mean = 600, sd = 100) + sin(1:366 * 2 * pi / 365) * 150,
      rnorm(366, mean = 400, sd = 80)  + sin(1:366 * 2 * pi / 365) * 100
    ),
    region = rep(sample(c("Europe", "Amérique", "Asie"), 366 * 4, replace = TRUE)),
    categorie = rep(sample(c("Électronique", "Mode", "Maison", "Sport"), 366 * 4, replace = TRUE))
  )
  
  ventes_ecommerce$ventes <- pmax(ventes_ecommerce$ventes, 0)
  
  # Calcul des KPI
  kpi1 <- ggplot() +
    annotate("text", x = 1, y = 1, label = paste0("Total Revenue:\n", format(sum(ventes_ecommerce$ventes), big.mark = " ", scientific = FALSE), " €"), size = 6, fontface = "bold") +
    theme_void()
  
  kpi2 <- ggplot() +
    annotate("text", x = 1, y = 1, label = paste0("Avg Daily Revenue:\n", round(mean(ventes_ecommerce$ventes), 0), " €"), size = 6, fontface = "bold") +
    theme_void()
  
  top_region <- ventes_ecommerce %>%
    group_by(region) %>%
    summarise(total = sum(ventes)) %>%
    arrange(desc(total)) %>%
    slice(1) %>%
    pull(region)
  
  kpi3 <- ggplot() +
    annotate("text", x = 1, y = 1, label = paste0("Top Region:\n", top_region), size = 6, fontface = "bold") +
    theme_void()
  
  top_cat <- ventes_ecommerce %>%
    group_by(categorie) %>%
    summarise(total = sum(ventes)) %>%
    arrange(desc(total)) %>%
    slice(1) %>%
    pull(categorie)
  
  kpi4 <- ggplot() +
    annotate("text", x = 1, y = 1, label = paste0("Top Category:\n", top_cat), size = 6, fontface = "bold") +
    theme_void()
  
  # Évolution des ventes
  evolution <- ventes_ecommerce %>%
    group_by(date, canal) %>%
    summarise(ventes_jour = sum(ventes), .groups = 'drop') %>%
    group_by(canal) %>%
    arrange(date) %>%
    mutate(ventes_lissees = zoo::rollmean(ventes_jour, k = 7, fill = NA))
  
  p_evolution <- ggplot(evolution, aes(x = date, y = ventes_lissees, color = canal)) +
    geom_line(size = 1.2, alpha = 0.8) +
    scale_color_brewer(type = "qual", palette = "Set1") +
    scale_x_date(date_labels = "%b", date_breaks = "2 months") +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = "Évolution des Ventes par Canal",
      subtitle = "Moyenne mobile sur 7 jours",
      x = NULL,
      y = "Ventes (€)",
      color = "Canal"
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.title = element_text(size = 14, face = "bold")
    )
  
  # Performance par canal
  perf_canal <- ventes_ecommerce %>%
    group_by(canal) %>%
    summarise(ca_total = sum(ventes), .groups = 'drop') %>%
    arrange(desc(ca_total))
  
  p_canaux <- ggplot(perf_canal, aes(x = reorder(canal, ca_total), y = ca_total / 1000)) +
    geom_col(fill = "steelblue", alpha = 0.8) +
    geom_text(aes(label = paste0(round(ca_total / 1000), "k€")), hjust = -0.1, fontface = "bold") +
    coord_flip() +
    labs(title = "Chiffre d'Affaires par Canal", x = NULL, y = "CA Total (k€)") +
    theme_minimal() +
    theme(panel.grid.major.y = element_blank(), plot.title = element_text(size = 14, face = "bold"))
  
  # Répartition géographique
  geo_data <- ventes_ecommerce %>%
    group_by(region) %>%
    summarise(ca_total = sum(ventes), .groups = 'drop') %>%
    mutate(pourcentage = ca_total / sum(ca_total) * 100)
  
  p_geo <- ggplot(geo_data, aes(x = "", y = pourcentage, fill = region)) +
    geom_col(width = 1) +
    coord_polar("y", start = 0) +
    scale_fill_brewer(type = "qual", palette = "Pastel1") +
    geom_text(aes(label = paste0(round(pourcentage, 1), "%")), position = position_stack(vjust = 0.5), fontface = "bold") +
    labs(title = "Répartition Géographique", fill = "Région") +
    theme_void() +
    theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5), legend.position = "bottom")
  
  # Répartition par catégorie
  cat_data <- ventes_ecommerce %>%
    group_by(categorie, canal) %>%
    summarise(ca_total = sum(ventes), .groups = 'drop')
  
  p_categories <- ggplot(cat_data, aes(x = categorie, y = ca_total / 1000, fill = canal)) +
    geom_col(position = "dodge", alpha = 0.8) +
    scale_fill_brewer(type = "qual", palette = "Set2") +
    labs(title = "CA par Catégorie et Canal", x = "Catégorie", y = "CA (k€)", fill = "Canal") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "bottom", plot.title = element_text(size = 14, face = "bold"))
  
  # Assemblage du dashboard
  dashboard <- (kpi1 + kpi2 + kpi3 + kpi4) /
    (p_evolution) /
    (p_canaux + p_geo + p_categories)
  
  dashboard_final <- dashboard +
    plot_annotation(
      title = "DASHBOARD E-COMMERCE - ANNÉE 2024",
      subtitle = "Vue d'ensemble des performances de vente",
      caption = "Source: Base de données interne | Mise à jour: Décembre 2024",
      theme = theme(
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(size = 14, hjust = 0.5, color = "gray50"),
        plot.caption = element_text(size = 10, color = "gray70")
      )
    )
  
  # Sauvegarde du dashboard
  ggsave(
    filename = paste0("C:/Users/loghd/Documents/dashboard_", format(Sys.Date(), "%Y%m%d"), ".png"),
    plot = dashboard_final,
    width = 16,
    height = 12,
    dpi = 300
  )
  
  # Journalisation du succès
  cat(paste0("Dashboard generated successfully on ", Sys.time(), "\n"),
      file = "C:/Users/loghd/Documents/Dashboard.log", append = TRUE)
  
}, error = function(e) {
  # Log the error
  cat(paste0("Error on ", Sys.time(), ": ", e$message, "\n"),
      file = "C:/Users/loghd/Documents/Dashboard.log", append = TRUE)
})