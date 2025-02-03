# Tech-Haven-Post-Pandemic-Analysis

Table of Contents

- [Project Background](#project-background)
- [Executive Summary](#executive-summary)
- [Insights Deep-Dive](#insights-deep-dive)
    - [Sales Trends and Growth Rates](#sales-trends-and-growth-rates)
    - [Key Product Performance](#key-product-performance)
    - [Customer Growth and Repeat Purchase Trends](#customer-growth-and-repeat-purchase-trends)
    - [Loyalty Program Performance](#loyalty-program-performance)
    - [Purchase Platform](#purchase-platform)
    - [Refund Rate Trends](#refund-rate-trends)
- [Recommendations](#recommendations)

## Project Background

Tech Haven, an e-commerce company founded in 2019, specializes in selling popular electronics like Apple, Samsung, and ThinkPad products. I'm partnering with the Head of Operations to extract insights and deliver recommendations to improve performance across sales, product, and marketing teams.

## Executive Summary

Tech Haven’s analysis of approximately 214k orders across 2020-2023 reveals a significant drop in annual revenue, as revenue in 2023 is nearly half of what it was in 2020. The surge in sales during 2020 and 2021 can largely be attributed to the pandemic. High-AOV products like laptops continue to generate the most revenue, while lower-cost items such as charging cables and batteries have a higher order count, but contribute less to overall revenue. Customer retention is a concern as unique and repeat purchase rates have declined by 39% and 61%, respectively. By targeting growth in the Midwest and Northeast regions and improving digital channels like the mobile app, Tech Haven can enhance customer loyalty, strengthen its market position, and drive sustainable growth.

![Tech Haven ERD](https://github.com/user-attachments/assets/aef2ba03-11d9-4e80-bd39-9ca2bb4d3c68)

## Insights Deep-Dive

### Sales Trends and Growth Rates

- Tech Haven averages $8.7 million in sales and 53,420 orders each year
- Sales surged in 2020 due to the pandemic, but declined by 38% by 2022
- Tech Haven shows seasonality, with peak sales in December and the lowest sales in February
- California brings in the most revenue, accounting for 13.2% of the total, followed by Texas (7.1%) and Florida (6.3%)

<p align="center">
  <img src="Data/Sales Trends and Growth Rates.png" style="margin-bottom: 20px;" />

<p align="center">
  <img src="Data/Total Sales by Month.png" width="250" height="190" style="display:inline-block; margin-right:10px;" />
  <img src="Data/AOV by Month.png" width="250" height="190" style="display:inline-block; margin-right:10px;" />
  <img src="Data/Total Orders by Month.png" width="250" height="190" style="display:inline-block;" />
</p>


<p align="center">
  <img src="Data/Sales Growth Rate.png" width="250" height="160" style="display:inline-block; margin-right:10px;" />
  <img src="Data/AOV Growth Rate.png" width="250" height="160" style="display:inline-block; margin-right:10px;" />
  <img src="Data/Order Growth Rate.png" width="250" height="160" style="display:inline-block;" />
</p>

### Key Product Performance

- The Macbook Pro Laptop, with its high AOV of $1,700, accounts for nearly a quarter of all revenue

- The 27in 4K Gaming Monitor and Bose SoundSport Headphones both have notably higher refund rates, with 6.9% and 7.1%, respectively.

- Laptops and phones account for 62.9% of all revenue

- Generally, products with the highest order count percentage tend to generate the lowest revenue.

<img src="Data/Product Performance (Even Larger).png" />

### Customer Growth and Repeat Purchase Trends

- Unique customers have steadily decreased from 55,742 in 2020 to 33,846 in 2023, showing a decline of about 39% over the four years.

- Repeat customer numbers have also decreased, from 10,586 in 2020 to 4,119 in 2023, reflecting a decrease of approximately 61%.

- The repeat rate has been consistently dropping each year, from 19.0% in 2020 to 12.2% in 2023, signaling a growing challenge in maintaining customer loyalty and encouraging repeat business.

<p align="center">
<img src="Data/Unique and Repeat Customer Table.png" />
</p>

### Loyalty Program Performance

- Loyalty sales have seen a major drop of 66.8% from 2020 to 2023, while nonloyalty sales have only decreased by 36.8% over the same time period.

- Orders from both loyalty and nonloyalty customers decreased in line with sales, with loyalty orders dropping by 66.7% and nonloyalty orders falling by 36.2%.

- The AOV for loyalty customers shows more fluctuation year to year compared to nonloyalty customers.

- Sales from both loyalty and nonloyalty customers dropped significantly in 2022, with loyalty customers experiencing a steeper decline of 46.4%.

<p align="center">
  <img src="Data/Loyalty Program Performance.png" />
</p>

<p align="center">
    <strong>Monthly Metrics and Growth Rates Per Year</strong>

<p align="center">
  <img src="Data/Total Revenue by Month (Loyalty Program).png" width="250" height="180" />
  <img src="Data/AOV by Month (Loyalty Program).png" width="250" height="180" />
  <img src="Data/Total Orders by Month (Loyalty Program).png" width="250" height="180" />
</p>

### Purchase Platform

- The mobile app accounts for only 8.82% of total sales, indicating a need for improvements to attract more customers to this platform.

- The website has a moderately higher AOV of $166 compared to the mobile app's $148, indicating customers tend to make smaller, quicker purchases on the app.

<p align="center">
  <img src="Data/Purchase Platform.png" />
</p>


### Refund Rate Trends

- The refund rate in 2020 was notably higher than in any of the following years.

- While the refund rate declined for nonloyalty customers each year, it varied more for loyalty customers.

- The overall refund rate for loyalty customers (4.2%) is higher than for nonloyalty customers (3.6%), though nonloyalty customers had a higher refund rate in both 2020 and 2021.

<p align="center">
  <img src="Data/Loyalty Program Impact on Refund Rates (Better One).png" />
</p>

## Recommendations

**Maximize Product Offerings**

- **Expand High-Performing Categories**: Increase catalog variations in laptops, phones, and monitors to meet diverse customer needs with premium models, driving repeat purchases and solidifying market presence.
- **Consider bundling lower-revenue products with high-revenue products**: Reevaluate the pricing strategy of charging cables and batteries, bundle them with high-value items, or offer them as a promotional gift to increase average order value (AOV) and revenue contribution.

**Customer Growth and Retention**

- **Boost Repeat Purchases**: Target single-purchase customers with personalized re-engagement campaigns and introduce tiered rewards within the loyalty program to incentivize frequent purchases and improve retention.
- **Leverage Core Customer Insights**: Analyze behaviors and preferences of repeat customers to enhance loyalty campaigns. Introduce referral incentives to drive word-of-mouth growth and increase new customer acquisition from existing networks.

**Loyalty Program Enhancements**

- **Enhance Loyalty Onboarding**: Implement targeted onboarding campaigns with first-purchase discounts or early access offers. Tiered rewards will further incentivize frequent purchases and strengthen customer loyalty.
- **Data-Driven Program Refinement**: Continuously monitor loyalty metrics to refine program offerings based on data, ensuring sustained engagement and effectiveness.

**Maintain Low Refund Rate**

- **Investigate Products with a High Refund Rate**: Analyze the factors behind the high return rate for products like the 27in 4K Gaming Monitor and the Bose SoundSport Headphones to identify potential quality or customer satisfaction issues and take steps to reduce future returns.

**Optimize Purchase Platform**

- **Enhance Mobile App Experience**: Improve the mobile app's checkout and personalization features to capitalize on rising mobile usage and increase its contribution to total sales.

**Regional Growth Strategies**

- **Focus on High Performing Regions**: Continue allocating resources to the South and West regions of the U.S. with regionalized marketing and product availability strategies tailored to local preferences.
