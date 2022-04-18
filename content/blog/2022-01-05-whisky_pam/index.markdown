---
title: "Grouping Whisky Brands"
subtitle: ""
excerpt: "Using Partition Around Medoids (PAM) for grouping brands of whisky."
date: 2022-04-09
author: "Wesley Satelis"
draft: false
# layout options: single, single-sidebar
layout: single-sidebar
bibliography: "referencias.bib"

# categories:
# - evergreen
---

In this post we will be using the unsupervised grouping method Partition Around Medoids (PAM), to create clusters of whisky brands based on ratings given by users of the website https://www.whiskybase.com/whiskies/brands. The PAM method is a variation of the widely known k-means, the main difference from k-means and PAM is that PAM uses observations in the dataset as cluster centroids, while k-means uses the cluster mean instead.

<!-- More details can be found in @van2003new. -->

The original dataset has the following variables.

-   **Brand:** Whisky brand;
-   **Country:** Country of origin of the whisky;
-   **Whiskies:** Number of different whiskies;
-   **Votes:** Number of votes given to that brand;
-   **Rating:** *(0-100)* Rating given by a regular user to that whisky;
-   **WB Ranking:** *(A - G)* Ranking based on ratings given by specialists in whisky.

The first part of any data related work should be always exploratory. Even when we use unsupervised methods.

The following table shows how many whisky brand each country has, I chose to not show countries with less than 10 whisky brands since those have too few brands and wouldn’t yield very interesting results.

<table>
<thead>
<tr>
<th style="text-align:center;">
Country
</th>
<th style="text-align:center;">
Number of whisky brands
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Scotland
</td>
<td style="text-align:center;">
3670
</td>
</tr>
<tr>
<td style="text-align:center;">
United States
</td>
<td style="text-align:center;">
1421
</td>
</tr>
<tr>
<td style="text-align:center;">
Germany
</td>
<td style="text-align:center;">
401
</td>
</tr>
<tr>
<td style="text-align:center;">
Ireland
</td>
<td style="text-align:center;">
322
</td>
</tr>
<tr>
<td style="text-align:center;">
Canada
</td>
<td style="text-align:center;">
161
</td>
</tr>
<tr>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
130
</td>
</tr>
<tr>
<td style="text-align:center;">
France
</td>
<td style="text-align:center;">
118
</td>
</tr>
<tr>
<td style="text-align:center;">
Switzerland
</td>
<td style="text-align:center;">
106
</td>
</tr>
<tr>
<td style="text-align:center;">
United Kingdom
</td>
<td style="text-align:center;">
86
</td>
</tr>
<tr>
<td style="text-align:center;">
Australia
</td>
<td style="text-align:center;">
82
</td>
</tr>
<tr>
<td style="text-align:center;">
Austria
</td>
<td style="text-align:center;">
76
</td>
</tr>
<tr>
<td style="text-align:center;">
Netherlands
</td>
<td style="text-align:center;">
55
</td>
</tr>
<tr>
<td style="text-align:center;">
Sweden
</td>
<td style="text-align:center;">
41
</td>
</tr>
<tr>
<td style="text-align:center;">
Belgium
</td>
<td style="text-align:center;">
30
</td>
</tr>
<tr>
<td style="text-align:center;">
India
</td>
<td style="text-align:center;">
28
</td>
</tr>
<tr>
<td style="text-align:center;">
Denmark
</td>
<td style="text-align:center;">
24
</td>
</tr>
<tr>
<td style="text-align:center;">
New Zealand
</td>
<td style="text-align:center;">
22
</td>
</tr>
<tr>
<td style="text-align:center;">
Czech Republic
</td>
<td style="text-align:center;">
17
</td>
</tr>
<tr>
<td style="text-align:center;">
Spain
</td>
<td style="text-align:center;">
13
</td>
</tr>
<tr>
<td style="text-align:center;">
Taiwan
</td>
<td style="text-align:center;">
10
</td>
</tr>
</tbody>
</table>

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672"  style="display: block; margin: auto;" />

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672"  style="display: block; margin: auto;" />
