# Overview
Using Tableau you can quickly get insight into the data if the data comes from various sources including data warehouse like Amazon Redshift. In this lab you will
 * Connect your Tableau Desktop to a Redshift cluster you just launched and loaded data into tables.
 * Create data sources in Tabluea Desktop to create insight into the data.
 * Dive deep into the data to do dive deep analysis.
 
# Install and Connect Tableau Dekstop

Following steps needs to be performed in your local enviroment in order to install Tableau Desktop and connect the TD to the Redshift cluster you launched.

* Your Windows environment might already have Tableau installed. Look for "Tableau 2018.3" icon on desktop. If it does not have Tableau Desktop, download [Tableau Desktop](https://www.tableau.com/products/desktop/download) and install in your local environment. You need to provide your email id to be able to download the software. Please note this is a 14-day trial version.
* Open **Tableau Dekstop** by clicking the desktop icon.
* From the left pane under **Connect** > **To a Server** select **Amazon Redshift**.
* Provide the connection information of the Redshift database
  * Server: Redshift endpoint this should look like *democluster.cqga9q1t5wyf.us-east-2.redshift.amazonaws.com*
  * Port : should be 8192
  * Database: Should be *demodb*.
  Leave Require SSL unchecked.
 * Once you click on Sign In it will connect to the server and the Connections pane will open.
 
 # Create Data Source
 The first step of doing analysis on data residing in Redshift is to create data sources. Once you are connected to the Redshift cluster follow the below steps to create data sources.
 ## RacePoints data source
 * Under **Schema** select the schema where the tables are created. In this case you should select *demo_local*. 
 * You will create a data source named "RacePoints" and it will include *f1_results, f1_races, f1_driver, f1_constructors* tables from the demo_local schema. You can select the tables from the left pane by either double clicking on the tables or dragging them onto the right section marked as "Drag tables here". Name this data source as "RacePoints".
 * Review the Join clauses on the right side where you can see a ![venn diagram icon](https://github.com/saunakc/redshift-workshop/blob/master/table-design/tableau_Join_icon.png) icon between the tables. The right join clause should be like below
    ```
     f1_results.ConstructorID  = f1_constructors.ConstructorID 
     f1_results.DriverID = f1_drivers.DriverID
     f1_results.RaceID = f1_races.RaceID
    ```
    
 ## LapTimes data source
 * Form the file menu click on Data > New Data Source and select Amazon Redshift. In the Amazon Redshift dialog box just type in the password for the rsadmin user. Rest of the fields should already pre-populated from the already setup connection.
 * Under **Schema** select the schema where the tables are created. In this case you should select *demo_local*. 
 * You will create a data source named "LapTimes" and it will include *f1_results, f1_races, f1_driver, f1_constructors*, *f1_lap_times* tables from the demo_local schema. Name this data source as "LapTimes". The right join clause should be like below
  ```
     f1_results.ConstructorID  = f1_constructors.ConstructorID 
     f1_results.DriverID = f1_drivers.DriverID
     f1_results.RaceID = f1_races.RaceID
     f1_results.DriverID = f1_lap_times.DriverID AND f1_results.RaceID = f1_lap_times.RaceID
   ```
  * Select **Extract** ( NOT Live) from the top right corner. We will be analying the exisiting data here so will pull these 4 tables from the Redshift cluster into the Tableau Desktop before doing the analyis. It will look like
 ![RacePoints data source](https://github.com/saunakc/redshift-workshop/blob/master/table-design/tableau_racepoints_datasource.png)
Hit Update Now. 
    
# Analysis
## Race Points

 * Click on Sheet 1 in the bottom. Rename the sheet as "Points". Select the "RacePoints" data source from the top left.
 * Now you have access to all the Dimensions and the Measures that Tableau has already figured out for you. Note not all measures identified by Tabluea are considered as measures since they are Id column. But for now let's focus on the relevant measures for quick analysis.
 * From the Dimensions on the left, double click on *f1_races > Year*, *f1_constructors > Name* and from the measures double click on *f1_results > Points*. Notice each time you add a dimension or measure the chart on the right is changing.
 * Once you selected Year, Name and Points change the chart types to see some of the top Constructors over the years. For example change the chart type to *treemaps*, *packed bubbles*. 
 * Notice there are too many boxes or bubbles. To focus on the most predominant ones in the recent years filter on Year > 2010 and remove Year from the chart. Under bubble chart it will look like below
 ![bubble chart top constructors](https://github.com/saunakc/redshift-workshop/blob/master/table-design/tableau_racepoints_top_constructors_2010onwards.jpg)
 Now you know who the top players are in the F1 world.
 
 ## Lap Times
 
 * Click on Sheet 2 in the bottom. Rename the sheet as "Lap Times". Select the "LapTimes" data source from the top left.
 * Drag Year and (Constructor) Name from the Dimensions on to filters and set Year filter > 2010. Set Name filters as the top constructors you have found under Points sheet.
 * We will be checking the lap times only for the winners in each race. Since the winner field is not there we will use the *Positionorder*  field from the f1_results table. However since that field is categorized as Measure you need to right click on it and select **Convert to Dimension**. Now drag Positionorder field to Filters and set filter to value "1".
 * Now select Year, Constructor Name and drag them to Columns.
 * Select f1_lap_times > Milliseconds and drag it to Rows. Change the calculation to the Average and not Sum.
 * Also pull in the f1_driver > Driverref if you are interested to know who the drivers are winning in the recent years. The chart will look like below-
 ![tap times](https://github.com/saunakc/redshift-workshop/blob/master/table-design/tableau_laptimes_recent_years.jpg)
 
