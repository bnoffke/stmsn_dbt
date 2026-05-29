{% docs x_coord %}
This represents the x-coordinate for the geographic location of the parcel.
{% enddocs %}

{% docs y_coord %}
This represents the y-coordinate for the geographic location of the parcel.
{% enddocs %}

{% docs geom %}
This refers to the geometric representation of the parcel in a spatial format.
{% enddocs %}

{% docs geom_4326 %}
This column typically represents geographical data in the WGS 84 coordinate system, which uses latitude and longitude degrees as coordinates. It's often used in mapping and spatial analysis to accurately position features on the Earth's surface.
{% enddocs %}

{% docs geom_local %}
Geographic representation of the local area, typically in a format such as a polygon or point, which delineates the boundaries or features of a specific district. This data is essential for mapping, spatial analysis, and understanding the layout of the municipality.
{% enddocs %}

{% docs shape_length %}
This indicates the total length of the property’s perimeter.
{% enddocs %}

{% docs shape_area %}
This provides the total area measurement of the property, typically in square feet or acres.
{% enddocs %}

{% docs st_transform %}
This function reprojects geometries to a different coordinate reference system (CRS). It is commonly used in spatial analysis to ensure that geometrical data aligns correctly with other spatial datasets, facilitating accurate mapping and analysis. The transformation process adjusts the coordinates of the geometries based on the specified target CRS.
{% enddocs %}

{% docs intersect_area %}
This value represents the area of overlap between the parcel and the area plan, calculated to assess the extent of alignment or conflict with planning objectives.
{% enddocs %}

{% docs intersect_rank %}
This column ranks the intersections based on their intersected area, providing a relative indication of significance or priority for planning considerations.
{% enddocs %}
