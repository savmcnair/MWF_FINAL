# MWF_FINAL
Final Project for MWF

*Introduction* This final project will represent the development of a dynamic app for exploring data from the European Values Survey (Wave 6). The app allows the user to explore data at the country-based and aggregate dataset level, looking at outcomes such as perception of the impact of mothers working on children and the impact of immigrant populations on job scarcity. The user can explore the distribution of these outcomes as well as age. They can also explore regression models of these variables with sex or education as a control; this regression model will also include an age polynomial as selected by the user. A final function will allow the user to download an Rmd report in pdf format of these analyses and visualizations.

*Organization* This repository contains a nested file structure. Here is an outline of all components:
- dynamic_analysis: The local folder with Rshiny app and relevant data folder for relative paths.
    - data: Houses the necessary datafiles for this project.
    - rsconnect: Dependencies for deploying the app online.
    - app.R: the local Rshiny app.
    - report.Rmd: R Markdown script to create dynamic html reports.
- scripts: contains all of the precursor scripts to the app for data cleaning, developing plots, and deploying the app.
    - clean_data: takes the large EVS data file and parses it down to the relevant data for this project.
    - deploy_app: code to deploy the local app online.
- README

*Instructions* To run the app locally:

Clone this full repository to your local computer.
Run clean_data, in 'scripts'.
Navigate to dynamic_analysis\app.R. Open this file. In the top right of the script window, press "Run App".
This will locally open the app! Rejoice!

The online version of this app can be found here: 
https://savmcnair.shinyapps.io/dynamic_analysis/ 