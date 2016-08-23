
shinyUI(
  pageWithSidebar(
    # Header:
    headerPanel("Convertisseur de matrices"),
    
# Input in sidepanel:
    sidebarPanel(
      # choix de la transformation
      radioButtons("trans", "Quelle transformation :",
                   list("i j fij => matrice" = "t1",
                        "matrice => i j fij" = "t2")
                   ),
    #import file
      fileInput("file", "Import du fichier"),
      p(textOutput("dwld"),"lignes importées"),
      
  #affichag du dwld button 
      conditionalPanel(
        condition = "output.dwld",
        h6("Export du fichier"),
        downloadButton('downloadData', 'Download')
        )
      ),
# Main:
    mainPanel(
      htmlOutput("test"),
      htmlOutput("tin"),
      tableOutput("table"),
      htmlOutput("tout"),
      tableOutput("table2")
    )
  )
)


