---
title: "Grouping Whisky Brands"
subtitle: ""
excerpt: "Using Partition Around Medoids (PAM) for grouping brands of whisky."
date: 2022-01-14
author: "Wesley Satelis"
draft: false
# layout options: single, single-sidebar
layout: single
bibliography: "referencias.bib"

categories:
- evergreen
---

# Introdução

Neste trabalho foram analisadas notas dadas a diferentes marcas de whisky, por usuários do site https://www.whiskybase.com/whiskies/brands. As marcas estão dispostas por país de origem, classificação de especialistas, número de whiskies, número de votos e notas de usuários.

O objetivo desta análise foi agrupar as marcas de whisky utilizando as notas datas por usuários do site como atributo. Os grupos resultantes foram comparados com as classificações feitas por especialistas em whiskies, ordenadas de A a G, e o método de agrupamento utilizado foi o de Particionamento Baseado em Medóides ou *Partition Around Medoids (PAM)*.

# Métodos

## Particionamento Baseado em Medóides

O método de particionamento baseado em medóides proposto por Kaufman and Rousseeuw (2009), é uma modificação do K-means. O método de agrupamento k-means visa agrupar atributos em um número de grupos pré-especificado. Usualmente itens são realocados de forma a minimizar o quadrado da sua distância euclidiana em relação ao centróide do grupo.

A distância euclidiana é utilizada para compor o que chamamos de matriz de dissimilariades. Seja `\(\mathbf{x}_{i}=\left(x_{i 1}, \cdots, x_{i r}\right)^{\tau}\)` e `\(\mathbf{x}_{j}=\left(x_{j 1}, \cdots, x_{j r}\right)^{\tau}\)` dois pontos em `\(R^{r}\)`. Então, a matriz de dissimilaridades é definida como

`$$d\left(\mathbf{x}_{i}, \mathbf{x}_{j}\right)=\left[\left(\mathbf{x}_{i}-\mathbf{x}_{j}\right)^{\tau}\left(\mathbf{x}_{i}-\mathbf{x}_{j}\right)\right]^{1 / 2}=\left[\sum_{k=1}^{r}\left(x_{i k}-x_{j k}\right)^{2}\right]^{1 / 2}.$$`

O algoritmo k-means é descrito a seguir.

1.  Considera um conjunto de características `\(X_{n\mathrm{x}p}\)` e a matriz de dissimilaridades.

2.  Dentro de uma “caixa” que engloba os dados, escolha aleatoriamente `\(K\)` pontos `\(c_{1}, ..., c_{k}\)` para `\(j=1, ..., K\)`. Os pontos `\(c_{i}\)` são chamados centróides.

3.  Conecta a observação `\(x_{i}\)` ao centróide `\(j\)` de menor distância. Troca a etiqueta `\(i\)` por `\(j\)`.

4.  Atualiza

`\(\mathbf{c}_{j}=\arg \min _{\mathbf{c} \in \mathbb{R}^{p}} \frac{1}{N_{j}} \sum_{i=1}^{n} \mathbf{1}\{i\)` está no cluster `\(j\} d^{2}\left(\mathbf{x}_{i}, \mathbf{c}\right),\)`

em que `\(N_{j}\)` é o número de observações no agrupamento `\(j\)`.

5.  Atualiza as etiquetas e itera 3 e 4 até que as observações não mudem de grupo.

O PAM se diferencia do K-means pois procura por objetos, candidatos de centróides, entre as observações e tenta minimizar a distância com outros objetos dentro do grupo, trocando de candidato sempre que isso reduzir o valor da função objetivo. Mais detalhes podem ser encontrados em Van der Laan, Pollard, and Bryan (2003).

## Gráficos de silhueta

Gráficos de silhueta são utilizados para determinar o número ideal de grupos. Suponha que `\(C_k\)` seja um agrupamento com `\(K\)` grupos.

Vamos primeiro definir as medidas de silhueta. Seja `\(c(i)\)` o grupo que contem o `\(i\)`-ésimo item e `\(a_i\)` a similaridade média deste `\(i\)`-ésimo elemento em relação à todos os outros membros do mesmo agrupamento `\(c(i)\)`. Agora, considere `\(c\)` como algum outro grupo diferente de `\(c(i)\)`, e seja `\(d(i,c)\)` a similaridade média entre o `\(i\)`-ésimo grupo com todos os membros de `\(c\)`. Calcule `\(d(i,c)\)` para todos os demais grupos que não são `\(c\)`. Definindo `\(b_{i}=\min _{c \neq c(i)} d(i, c)\)`, se `\(b_i = d(i,c)\)`, então `\(c\)` é chamado de vizinho do `\(i\)`-ésimo item e é considerado o segundo melhor grupo para o `\(i\)`-ésimo item.

O `\(i\)`-ésimo valor de silhueta é dado por

$$
s_{i}\left(C_{K}\right)=s_{i K}=\frac{b_{i}-a_{i}}{\max \left\{a_{i}, b_{i}\right\}},
$$

de forma que `\(-1 \leq s_{i K} \leq 1\)`. Valores positivos e altos para `\(s_{i K}\)` indicam que o `\(i\)`-ésimo item está bem alocado, valores negativos e altos para `\(s_{i K}\)` indicam um agrupamento ruim, e `\(s_{i K} \approx 0\)` indicam que o `\(i\)`-ésimo item está entre dois grupos. E ainda, se `\(\max _{i}\left\{s_{i K}\right\}<0.25\)`, o procedimento de agrupamento não encontrou grupos definidos.

Em um gráfico de silhueta todos os `\(\left\{s_{i K}\right\}\)` estão ordenados em ordem decrescente por grupo. `\(\bar{s}_{K}\)` é a média de todos os `\(\left\{s_{i K}\right\}\)` e é usada para definir o número ideal de grupos, bem como avaliar a qualidade de grupos separadamente. Mais informações podem ser encontradas em Izenman (2008).

# Agrupamento de marcas de whiskies

Foram utilizadas as notas dadas por usuários aos whiskies do site. A fim de compor uma métrica justa, também foi incorporado o número de votos que cada whisky recebeu, gerando uma nota suavizada. Assim, as novas notas foram recalculadas por

`$$\hat{u}_{j}^{(s)}=\frac{n_{j} \hat{u}_{j}+1}{n_{j}+2} \times 100 \%,$$`

em que `\(n_j\)` é o número de avaliadores, e `\(u_j\)` a nota média entre 0 e 1.

Foram consideradas somente avaliações feitas na Irlanda e marcas de whiskies com pelo menos 5 votos, resultando em um conjunto de 71 observações.

A Figura 1 mostra gráficos de agrupamentos para diferentes números de grupos prefixados. Os gráficos apenas ilustram o número de itens em cada grupo, devemos apenas nos atentar às cores, que discriminam os grupos, e ao número de observações em cada grupo. A variação ao longo do eixo `\(y\)` existe apenas para que que as observações não se sobreponham. Todos os agrupamentos foram feitos utilizando o método PAM, variando somente o número de grupos.

``` r
# load("dados_tratados.RData")
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
    ## ✓ tibble  3.1.6     ✓ dplyr   1.0.7
    ## ✓ tidyr   1.1.4     ✓ stringr 1.4.0
    ## ✓ readr   2.1.1     ✓ forcats 0.5.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(cluster)
library(factoextra)
```

    ## Welcome! Want to learn more? See two factoextra-related books at https://goo.gl/ve3WBa

``` r
library(data.table)
```

    ## 
    ## Attaching package: 'data.table'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

    ## The following object is masked from 'package:purrr':
    ## 
    ##     transpose

``` r
data <- read_csv("atividade1.csv") %>%
  filter(Country == "Ireland" & Votes >= 5) %>%
  select(-7) %>%
  drop_na() %>%
  group_by(Brand) %>%
  mutate(nota_suavizada =  ((Votes * (Rating/100) + 1)/(Votes + 2))*100) %>%
  ungroup()
```

    ## New names:
    ## * `` -> ...7

    ## Rows: 7157 Columns: 7

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (3): Brand, Country, WB Ranking
    ## dbl (3): Whiskies, Votes, Rating
    ## lgl (1): ...7

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
data_cluster <- select(data, nota_suavizada)

data <- setDT(data)
for(i in 2:5){
  cluster <- pam(data_cluster, i, keep.diss = T)$clustering
  data[, paste0("K = ", i) := cluster ]
}

data <- as_tibble(data) %>%
  gather(key="K", value="Cluster", "K = 2":"K = 5")

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
```

    ##   cluster size ave.sil.width
    ## 1       1   40          0.61
    ## 2       2   31          0.61
    ##   cluster size ave.sil.width
    ## 1       1   32          0.63
    ## 2       2   31          0.53
    ## 3       3    8          0.78
    ##   cluster size ave.sil.width
    ## 1       1   32          0.58
    ## 2       2   23          0.68
    ## 3       3    8          0.27
    ## 4       4    8          0.78
    ##   cluster size ave.sil.width
    ## 1       1   10          0.57
    ## 2       2   23          0.64
    ## 3       3   23          0.53
    ## 4       4    8          0.27
    ## 5       5    7          0.78

``` r
ggplot(data) +
  geom_jitter(aes(x=nota_suavizada, y=as.factor(Cluster),
                  colour=as.factor(Cluster))) +
  facet_wrap(~K, nrow=1) + 
  theme_bw() +
  labs(color='Grupo') + xlab("Notas suavizadas") + ylab("") +
    theme(axis.text.y=element_blank(),
          axis.ticks.y=element_blank())
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" alt="Gráficos de diferentes agrupamentos com K grupos. Variações ao longo do eixo `\(y\)` foram adicionadas apenas para que que as observações não se sobreponham e existem apenas na visualização dos dados." width="864" />
<p class="caption">
Figure 1: Gráficos de diferentes agrupamentos com K grupos. Variações ao longo do eixo `\(y\)` foram adicionadas apenas para que que as observações não se sobreponham e existem apenas na visualização dos dados.
</p>

</div>

Na Figura 2, temos os gráficos de silhueta para os mesmos agrupamentos expostos na Figura 1. Os agrupamentos com 4 e 5 grupos resultaram em alguns valores negativos de silhueta, apesar de não serem valores altos, é preferível evitar este tipo de resultado. As médias das silhuetas em cada agrupamento são maiores nos agrupamentos com 2 e 3 grupos, estes também não apresentam silhuetas negativas. Como o agrupamento com 2 grupos resultou em uma média de silhuetas maior que os demais, podemos dizer que este é o melhor cadidato dentre os testados. Assim, as notas de usuários foram agrupadas em dois grupos apenas.

``` r
library(gridExtra)
```

    ## 
    ## Attaching package: 'gridExtra'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     combine

``` r
grid.arrange(sil_plot[[1]], sil_plot[[2]], sil_plot[[3]], sil_plot[[4]])
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" alt="Gráficos de silhueta para diferentes agrupamentos com K grupos." width="864" />
<p class="caption">
Figure 2: Gráficos de silhueta para diferentes agrupamentos com K grupos.
</p>

</div>

Com o gráfico da Figura 3, temos o objetivo de comparar as classificações dadas por especialistas com os grupos formados pelas notas dos usuários. As notas dos especialistas e dos usuários não convergem e por fim temos cinco classificações em comparação com dois grupos, respectivamente.

``` r
data %>% 
  filter(K == "K = 2") %>% 
  ggplot(aes(x=nota_suavizada, y=as.factor(Cluster))) + 
  geom_jitter(aes(colour=`WB Ranking`, shape=as.factor(Cluster)), size=2) + 
  xlab("Nota suavizada") + ylab("") + 
  labs(color="Classificação dos\nespecialistas", shape="Nota dos usuários") +
  scale_x_continuous(breaks = round(seq(min(data$nota_suavizada),
                                        max(data$nota_suavizada), by = 5), 0)) +theme_bw() +
    theme(               axis.text.y=element_blank(),
                       axis.ticks.y=element_blank())
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" alt="Comparação do agrupamento de dois grupos, usando notas de usuários como atributo, e classificações dadas por especialistas em whiskies. Variações ao longo do eixo `\(y\)` foram adicionadas apenas para que que as observações não se sobreponham e existem apenas na visualização dos dados." width="576" />
<p class="caption">
Figure 3: Comparação do agrupamento de dois grupos, usando notas de usuários como atributo, e classificações dadas por especialistas em whiskies. Variações ao longo do eixo `\(y\)` foram adicionadas apenas para que que as observações não se sobreponham e existem apenas na visualização dos dados.
</p>

</div>

# Conclusões

Apesar de parecer que o agrupamento foi erroneo por não concordar com as classificações de especialistas, vale lembrar que se tratam de grupos de pessoas com habilidades diferentes.

Examinando mais de perto, nota-se que os usuários e especialistas tendem a concordar quanto às melhores marcas de whisky, marcas C. E também na maior parte das marcas D.

Faz sentido que as notas de especialistas apresentem mais grupos do que as notas de usuários, já que espera-se que estes sejam leigos no assunto e que especialistas tenham o paladar mais apurado para whiskies e sejam capazes de discernir melhor entre as categorias.

# Referências

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-izenman2008modern" class="csl-entry">

Izenman, Alan Julian. 2008. “Modern Multivariate Statistical Techniques.” *Regression, Classification and Manifold Learning* 10: 978–70.

</div>

<div id="ref-kaufman2009finding" class="csl-entry">

Kaufman, Leonard, and Peter J Rousseeuw. 2009. *Finding Groups in Data: An Introduction to Cluster Analysis*. Vol. 344. John Wiley & Sons.

</div>

<div id="ref-van2003new" class="csl-entry">

Van der Laan, Mark, Katherine Pollard, and Jennifer Bryan. 2003. “A New Partitioning Around Medoids Algorithm.” *Journal of Statistical Computation and Simulation* 73 (8): 575–84.

</div>

</div>

# Anexos

``` r
library(tidyverse)
library(cluster)
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
for(i in 2:5){
  cluster <- pam(data_cluster, i, keep.diss = T)$clustering
  data[, paste0("K = ", i) := cluster ]
}

data <- as_tibble(data) %>%
  gather(key="K", value="Cluster", "K = 2":"K = 5")

k_uniq <- unique(data$K)
silhuetas <- list()
for(i in 1:4){
  sil <- filter(data, K == k_uniq[i])
  silhuetas[[i]] <- silhouette(sil$Cluster, dist(sil$nota_suavizada))
}
```
