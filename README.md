# 🛒 SQL-Based-Business-Insights-for-Target

**Target** is a globally renowned brand and one of the leading retailers in the United States. It is known for delivering outstanding value, inspiration, innovation, and a superior guest experience—making it a preferred shopping destination for millions.

This business case focuses specifically on **Target's operations in Brazil**, offering insights derived from **100,000 orders placed between 2016 and 2018**. The dataset provides a comprehensive view across multiple dimensions including order status, pricing, payment and freight performance, customer location, product details, and customer reviews.

By analyzing this rich dataset, we can uncover valuable insights related to:

* Order processing and fulfillment
* Pricing strategies
* Payment and shipping efficiency
* Customer demographics
* Product attributes
* Customer satisfaction

---

## 📂 Dataset

The data is split across **8 CSV files**:

* `customers.csv`
* `sellers.csv`
* `order_items.csv`
* `geolocation.csv`
* `payments.csv`
* `reviews.csv`
* `orders.csv`
* `products.csv`

---

## 🧾 Column Descriptions

### `customers.csv`

| **Feature**                | **Description**                               |
| -------------------------- | --------------------------------------------- |
| `customer_id`              | ID of the consumer who made the purchase      |
| `customer_unique_id`       | Unique ID of the consumer                     |
| `customer_zip_code_prefix` | Zip Code of consumer’s location               |
| `customer_city`            | Name of the city from where the order is made |
| `customer_state`           | State code (e.g., São Paulo - SP)             |

---

### `sellers.csv`

| **Feature**              | **Description**                   |
| ------------------------ | --------------------------------- |
| `seller_id`              | Unique ID of the seller           |
| `seller_zip_code_prefix` | Zip Code of the seller’s location |
| `seller_city`            | Name of the seller’s city         |
| `seller_state`           | State code (e.g., São Paulo - SP) |

---

### `order_items.csv`

| **Feature**           | **Description**                      |
| --------------------- | ------------------------------------ |
| `order_id`            | Unique ID of the order               |
| `order_item_id`       | Unique ID for each item in the order |
| `product_id`          | Unique ID of the product             |
| `seller_id`           | Seller's unique ID                   |
| `shipping_limit_date` | Deadline for shipping the product    |
| `price`               | Price of the product                 |
| `freight_value`       | Shipping cost                        |

---

### `geolocation.csv`

| **Feature**                   | **Description**                |
| ----------------------------- | ------------------------------ |
| `geolocation_zip_code_prefix` | First 5 digits of the ZIP code |
| `geolocation_lat`             | Latitude                       |
| `geolocation_lng`             | Longitude                      |
| `geolocation_city`            | City                           |
| `geolocation_state`           | State                          |

---

### `payments.csv`

| **Feature**            | **Description**                                 |
| ---------------------- | ----------------------------------------------- |
| `order_id`             | Unique ID of the order                          |
| `payment_sequential`   | Payment sequence (in case of multiple payments) |
| `payment_type`         | Payment method (e.g., credit card)              |
| `payment_installments` | Number of installments                          |
| `payment_value`        | Total amount paid                               |

---

### `orders.csv`

| **Feature**                     | **Description**                         |
| ------------------------------- | --------------------------------------- |
| `order_id`                      | Unique ID of the order                  |
| `customer_id`                   | ID of the consumer                      |
| `order_status`                  | Order status (e.g., delivered, shipped) |
| `order_purchase_timestamp`      | Purchase timestamp                      |
| `order_delivered_carrier_date`  | Date carrier received the product       |
| `order_delivered_customer_date` | Actual delivery date to customer        |
| `order_estimated_delivery_date` | Estimated delivery date                 |

---

### `reviews.csv`

| **Feature**               | **Description**                     |
| ------------------------- | ----------------------------------- |
| `review_id`               | ID of the product review            |
| `order_id`                | Order ID associated with the review |
| `review_score`            | Customer rating (1–5 scale)         |
| `review_comment_title`    | Review title                        |
| `review_comment_message`  | Review content                      |
| `review_creation_date`    | Date the review was created         |
| `review_answer_timestamp` | Date the review was responded to    |

---

### `products.csv`

| **Feature**                  | **Description**                   |
| ---------------------------- | --------------------------------- |
| `product_id`                 | Unique ID of the product          |
| `product_category_name`      | Product category                  |
| `product_name_lenght`        | Length of the product name        |
| `product_description_lenght` | Length of the product description |
| `product_photos_qty`         | Number of product photos          |
| `product_weight_g`           | Weight in grams                   |
| `product_length_cm`          | Length in cm                      |
| `product_height_cm`          | Height in cm                      |
| `product_width_cm`           | Width in cm                       |

---

## 🔍 Use Cases

This dataset is ideal for:

* Building machine learning models for delivery time prediction
* Performing customer segmentation and behavior analysis
* Exploring payment and shipping performance trends
* Analyzing the impact of product features on reviews

---


## 📌 Tasks Performed

This analysis follows standard EDA procedures and dives deep into customer behavior, sales trends, delivery patterns, and payment methods in **Target's Brazilian e-commerce operations**.

---

### 🔍 Initial Exploration

* **Inspect Data Types**
  Examine the data types of all columns in the `customers.csv` file to understand the structure.

* **Time Range of Orders**
  Identify the date range during which the orders were placed using the `order_purchase_timestamp` column in `orders.csv`.

* **Customer Distribution by Geography**
  Count the number of unique cities and states from where customers placed orders within the given period.

---

### 📈 Trend & Seasonal Analysis

* **Yearly Order Growth**
  Analyze whether there's a growing trend in the number of orders over the years (2016–2018).

* **Monthly Seasonality**
  Explore any recurring monthly patterns in order volumes.

* **Order Time-of-Day Preferences**
  Determine when Brazilian customers most commonly place orders based on purchase time:

  | Time Range | Time of Day |
  | ---------- | ----------- |
  | 00–06 hrs  | Dawn        |
  | 07–12 hrs  | Morning     |
  | 13–18 hrs  | Afternoon   |
  | 19–23 hrs  | Night       |

---

### 🌍 Regional Evolution of E-Commerce

* **Monthly Orders by State**
  Track the number of orders placed **month by month** across all states.

* **Customer Distribution Across States**
  Visualize how customers are distributed geographically within Brazil.

---

### 💰 Economic Impact & Price Trends

* **Spending Trend (2017 → 2018)**
  Analyze the percentage increase in **order costs** from **January to August** using the `payment_value` column in `payments.csv`.

* **Order Value by State**

  * Total and average **order price** per state
  * Total and average **freight cost** per state

---

### 🚚 Delivery & Freight Analysis

* **Delivery Time Metrics**
  Calculate the delivery duration for each order using:

  ```
  time_to_deliver = order_delivered_customer_date - order_purchase_timestamp
  ```

* **Delivery Accuracy**
  Measure the difference between actual and estimated delivery dates using:

  ```
  diff_estimated_delivery = order_delivered_customer_date - order_estimated_delivery_date
  ```

* **Freight Cost Insights**

  * Identify the **top 5 states** with the **highest** and **lowest average freight values**

* **Delivery Time Insights**

  * Identify the **top 5 states** with the **fastest** and **slowest average delivery times**

* **Delivery Ahead of Estimate**

  * Find **top 5 states** where orders are delivered **significantly earlier** than estimated, based on the difference between actual and estimated delivery dates

---

### 💳 Payment Method Insights

* **Monthly Payment Type Usage**
  Get the **month-wise count** of orders based on **payment types** (e.g., credit card, debit card, boleto, etc.).

* **Installment Trends**
  Analyze the number of orders placed grouped by **installment count** (`payment_installments`), revealing how often customers opt for EMI-style purchases.

---
