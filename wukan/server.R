shinyServer(
  function(input, output) {
    Dataset <- reactive({
      if(input$trans=="t1"){
        text<-"<p><img src='fijtomato.png' width=300/></p>"
        if (is.null(input$file)) {
          df <- data.frame()
          df2 <- data.frame()
          dfr <- data.frame()
          df2r <- data.frame()
          tin<-""
          tout<-""
          dwld<-0
        }else{
        df <- as.data.frame(read.table(input$file$datapath,header=TRUE))
        names(df)<-c("i","j","fij")
        library("reshape2")
        df2 <- as.data.frame(dcast(df,i~j,value.var="fij"))
        names(df2)[1]<-""
        #gestion overview
        tin<-"Input overview (max 10 rows)"
        tout<-"Output overview (max 10 rows and 10 columns)"
        if (dim(df)[1]>10){nl1<-10}else{nl1<-dim(df)[1]}
        if (dim(df)[2]>10){nc1<-10}else{nc1<-dim(df)[2]}
        dfr<-df[1:nl1,1:nc1]
        if (dim(df2)[1]>10){nl1<-10}else{nl1<-dim(df2)[1]}
        if (dim(df2)[2]>10){nc1<-10}else{nc1<-dim(df2)[2]}
        df2r<-df2[1:nl1,1:nc1]
        dwld<-nrow(df)
        }
      }
      else {
        text<-"<p><img src='mattofij.png' width=300/></p>"
        if (is.null(input$file)) {
          df <- data.frame()
          df2 <- data.frame()
          dfr <- data.frame()
          df2r <- data.frame()
          tin<-""
          tout<-""
          dwld<-0
        }else{
          df <- as.data.frame(read.table(input$file$datapath,header=TRUE,row.names=NULL))
          library("reshape2")
          df2 <- melt(df,id.vars=1,variable.name="j",value.name="fij")
          names(df2)[1]<-"i"
          names(df)[1]<-""
          #gestion overview
          tin<-"Input overview (max 10 rows and 10 columns)"
          tout<-"Output overview (max 10 rows)"
          if (dim(df)[1]>10){nl1<-10}else{nl1<-dim(df)[1]}
          if (dim(df)[2]>10){nc1<-10}else{nc1<-dim(df)[2]}
          dfr<-df[1:nl1,1:nc1]
          if (dim(df2)[1]>10){nl1<-10}else{nl1<-dim(df2)[1]}
          if (dim(df2)[2]>10){nc1<-10}else{nc1<-dim(df2)[2]}
          df2r<-df2[1:nl1,1:nc1]
          dwld<-nrow(df)
        }
      }
      return(list(df=df,df2=df2,dwld=dwld,text=text,tin=tin,tout=tout,dfr=dfr,df2r=df2r))
    })

    
#gestion de l'affichage des images des transformations
    output$test <- renderText({
      Dataset()$text
    })

    
#gestion de l'affichage des headers input/output et de l'affichage des tables
    output$tin <- renderText({
      Dataset()$tin
    })       
    output$table<-renderTable({
      Dataset()$dfr
    },include.rownames=FALSE)   
    output$tout <- renderText({
      Dataset()$tout
    }) 
    output$table2<-renderTable({
      Dataset()$df2r
    },include.rownames=FALSE)
    
#gestion du download 
    output$dwld <- reactive({
     Dataset()$dwld  
    })
    
    output$downloadData <- downloadHandler(
     filename = function() {
       paste("output",input$file, sep='')
     },
     content = function(zile){ 
       write.table(Dataset()$df2,sep="\t",dec=".",quote=FALSE,row.names=FALSE,zile)}
   )
  }
)

