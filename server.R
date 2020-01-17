library(shiny)
library(calibrate)

function(input, output) {
  #LOAD FILE1
  dd1<-reactive({ 
    inFile1<-input$file1
    if (is.null(inFile1)) return(invisible(NULL))
    else {
      read.csv2(inFile1$datapath,sep = input$sep1,dec=input$dec1, header=TRUE, quote='')
    }
  })
  
  #OUTPUT FILE1 
  output$table1 <- renderTable(dd1()[c(1:8),c(1:9)])
  
  
  output$plot1<-renderPlot({
    plot(dd1()$logFC, dd1()$B, pch=20, main=paste0("Volcano plot of ",input$title), xlab="logFC",ylab="B value", xlim=c(min(dd1()$logFC),max(dd1()$logFC))) 
    
    with(subset(dd1(), B>input$Bvalue & abs(logFC>input$FC)), points(logFC, B, pch=20, col=input$color))
    with(subset(dd1(), B>input$Bvalue & logFC<input$FCm), points(logFC, B, pch=20, col=input$color))
    
    with(subset(dd1(), B>input$Bvalue & abs(logFC>input$FC)), textxy(logFC, B, labs=Gene.Symbol, cex=.7,offset=0.3))
    with(subset(dd1(), B>input$Bvalue & logFC<input$FCm), textxy(logFC, B, labs=Gene.Symbol, cex=.7,offset=0.3))
    
    abline(v=input$FCm,lty=3)
    abline(v=input$FC,lty=3)
    abline(h=input$Bvalue,lty=3)
    
  })
  
  #DOWNLOAD FILE1 
  output$down <- downloadHandler(
    filename = function() "figura.pdf",
    content = function(ff) {
      pdf(ff)
        plot(dd1()$logFC, dd1()$B, pch=20, main="Volcano plot", xlab="logFC",ylab="B value", xlim=c(min(dd1()$logFC),max(dd1()$logFC))) 
        
        with(subset(dd1(), B>input$Bvalue & abs(logFC>input$FC)), points(logFC, B, pch=20, col=input$color))
        with(subset(dd1(), B>input$Bvalue & logFC<input$FCm), points(logFC, B, pch=20, col=input$color))
        
        with(subset(dd1(), B>input$Bvalue & abs(logFC>input$FC)), textxy(logFC, B, labs=SymbolsA, cex=.7,offset=0.3))
        with(subset(dd1(), B>input$Bvalue & logFC<input$FCm), textxy(logFC, B, labs=SymbolsA, cex=.7,offset=0.3))
        
        abline(v=input$FCm,lty=3)
        abline(v=input$FC,lty=3)
        abline(h=input$Bvalue,lty=3)
      dev.off()
    })
}