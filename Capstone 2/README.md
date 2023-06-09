# Predicting house price in King County, WA, USA

Exploratory data analysis and price prediction on the King County (WA) house price data set using attributes or features such as square footage, number of bedrooms, number of floors and so on.

## Packages Required
common packages: pandas, numpy, seaborn, statsmodels.api, sklearn, matplotlib

folium for the geo heat map. Installation pip install folium

## Dataset Description
This dataset contains house sale prices for King County in Seattle, WA. It includes homes sold between May 2014 and May 2015. The dataset is retrieved from Kaggle. 

Along with house price (target) it consists of an ID, date, and 17 house features.

1. Id: Unique ID for each home sold
2. Date: Date of the home sale
3. Price: Price of each home sold (target)
4. Bedrooms: Number of bedrooms
5. Bathrooms: Number of bathrooms, where .5 accounts for a room with a toilet but no shower
6. Sqft_living: Square footage of the apartments interior living space
7. Sqft_lot: Square footage of the land space
8. Floors: Number of floors
9. Waterfront: A dummy variable for whether the apartment was overlooking the waterfront or not 10.View: An index from 0 to 4 of how good the view of the property was 11.Condition: An index from 1 to 5 on the condition of the apartment,
10. Grade: An index from 1 to 13, where 1-3 falls short of building construction and design, 7 has an average level of construction and design, and 11-13 have a high quality level of construction and design
11. Sqft_above: The square footage of the interior housing space that is above ground level
12. Sqft_basement: The square footage of the interior housing space that is below ground level
13. Yr_built: The year the house was initially built
14. Yr_renovated: The year of the house’s last renovation
15. Zipcode: What zipcode area the house is in
16. Lat: Lattitude
17. Long: Longitude
18. Sqft_living15: The square footage of interior housing living space for the nearest 15 neighbors
19. Sqft_lot15: The square footage of the land lots of the nearest 15 neighbors

## Future Work
As a recommendation for future work, it will be great to include the identifying characteristics such as amenities (swimming pool, gym room, etc), neighboring education facilities (reputable school and universities), and nearest distance to public transportation. These characteristics will help to determine the house price. Based on the characteristics, we could further segmentize the house into two categories, luxury house or ordinary house. A different model can be developed based on the house category.
