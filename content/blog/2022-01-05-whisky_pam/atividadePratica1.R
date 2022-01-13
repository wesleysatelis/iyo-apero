library(tidyverse)
library(cluster)
library(factoextra)
library(data.table)

data <- read_csv("atividade1.csv") %>% 
  filter(Country == "Ireland" & Votes >= 5) %>% 
  select(-X7) %>% 
  drop_na() %>% 
  group_by(Brand) %>% 
  mutate(nota_suavizada =  ((Votes * (Rating/100) + 1)/(Votes + 2))*100) %>% 
  ungroup()

data_cluster <- select(data, nota_suavizada)

data <- setDT(data)
for(i in 2:7){
  cluster <- pam(data_cluster, i, keep.diss = T)$clustering
  data[, paste0("K = ", i) := cluster ]
}

data <- as_tibble(data) %>% 
  gather(key="K", value="Cluster", "K = 2":"K = 7")

ggplot(data) +
  geom_jitter(aes(x=nota_suavizada, y=as.factor(Cluster), colour=as.factor(Cluster))) +
  facet_wrap(~K) + 
  theme_bw() +
  labs(color='Cluster') + xlab("New Rating") + ylab("Cluster")

k_uniq <- unique(data$K)
sil_plot <- list()
for(i in 1:4){
  sil <- filter(data, K == k_uniq[i])
  media_sil <- summary(silhouette(sil$Cluster, dist(sil$nota_suavizada)))$avg.width
  # data_sil <- silhouette(sil$Cluster, dist(sil$nota_suavizada))
  sil_plot[[i]] <- fviz_silhouette(silhouette(sil$Cluster, dist(sil$nota_suavizada))) +
    theme_bw() + theme(axis.title.x=element_blank(),
                       axis.text.x=element_blank(),
                       axis.ticks.x=element_blank()) +
                       # legend.title = "Grupo") + 
    guides(color=guide_legend(title="Grupo"), fill=guide_legend(title="Grupo")) +
    ylab("Comprimento da silhueta Si") +
    ggtitle(paste0("Comprimento médio das silhuetas: ", round(media_sil, 4)))
}

grid.arrange(sil_plot[[1]], sil_plot[[2]], sil_plot[[3]], sil_plot[[4]])

data %>% 
  filter(K == "K = 2") %>% 
  ggplot(aes(x=nota_suavizada, y=as.factor(Cluster))) + 
  geom_jitter(aes(colour=`WB Ranking`), size=2) + 
  theme_bw() + 
  xlab("New Rating") + ylab("Cluster")




