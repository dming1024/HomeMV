
#播放电视剧，每个电视剧在一个文件夹下
#www/电视剧1
#www/电视剧2
#www/电视剧3
#setwd("D:\\shiny\\shinyVideos")
library(shiny)

ui<-fluidPage(
  uiOutput("Mainui"),
  #textOutput("test"),
  #  tags$div(
  #    id="videos",
  #    tags$video(id="videoID", type = "video/mp4",src = "test.mp4",
  #               controls="controls",
  #               style="heigth:100px;width:200px;"),
  #    tags$p(id="description","that's it video!!!!"),
  #    style="padding:4px;heigth:120px;width:200px;float:left;"
  #  )
)

server <- function(input, output, session) {
  
  
  #moveName<-reactive({
  #  mvNames=list.files("www",pattern = "*.mp4")
  #  return(mvNames)
  #})
  
  seriesName<-reactive({
    seriesName=list.dirs("www/",full.names = F)[-1]
    return(seriesName)
  })
  
  AddmvFunction<-function(moveName){
    ui=tags$div(
      id="videos",
      tags$video(id="videoID", type = "video/mp4",src =sprintf("%s",moveName) ,
                 controls="controls",poster="poster.JPG",
                 style="heigth:100px;width:200px;"),
      tags$p(id="description",sprintf("%s",moveName)),
      style="padding:4px 5px 5px 5px;border:5px solid #D1EEEE;border-radius:25px;heigth:120px;width:220px;float:left"
    )
    return(ui)
  }
  
  #add mv button
  AddmvButton<-function(moveName){
    ui=tags$div(
      id="videos",
      actionButton(
        inputId=sprintf("%s",moveName),
        label = sprintf("%s",moveName),
        icon("play-circle"),
        style="background-color: #FFF8DC;width:100%;"
      ),
      #tags$p(id="description",sprintf("%s",moveName)),
      style="padding:2px 2px 2px 2px;border:2px solid #FFFFFF;border-radius:25px;width:20%;float:left;"
    )
    return(ui)
  }
  
  
  
  #添加分集剧情
  splitSeries<-function(series){
    mvNames=list.files(sprintf("www/%s/",series),pattern = "*.mp4")
    ui<-tags$div(
      id="series",
      
      tags$div(
        style="width:100%;height:20px;float:left;"
      ),
      tags$div(id="seriesName",
               tags$p(sprintf("%s",series),style="font-size:15px;font-weight:bold;"),
               style="width:100%;background-color:#EBEBEB;border:2px solid #EBEBEB;border-radius:5px;float:left;height:20px;"
               ),
      lapply(mvNames,AddmvButton),
      tags$div(
        tags$hr(),
        style="width:100%;height:20px;float:left;"
      ),
    )
      
    return(ui)
  }
  
  
  output$Mainui<-renderUI({
    fluidPage(
      includeCSS("packagestyle.css"),
      
      HTML(
        '
<div id="header">
<h1>家 庭 电 影 院</h1>
</div>

<div id="horizon_nav">
<ul>
  <li><a>主 页</a></li>
  <li><a href="" title="MV" target="_blank">电 影</a></li>
  <li><a href="" title="MV" target="_blank">电 视 剧</a></li>
  <li><a href="" title="MV" target="_blank">音 乐</a></li>
  <li><a href="" title="MV" target="_blank">照 片</a></li>

</ul>
</div>
'
      ),#end of HTML
      
      lapply(seriesName(),splitSeries)
      
    )
    
  })
  
  #  output$test<-renderText(
  #    {
  #     moveName()
  #    }
  #  )
  
  #播放MV,当一旦observe event事件出现后
  lapply(
    #每个series
    X=list.dirs("www/",full.names = F)[-1],
    FUN=function(j){
      #每个series下的mv
      lapply(
        X=list.files(sprintf("www/%s",j),pattern = "*.mp4"),
        FUN=function(i){
          observeEvent(input[[`i`]],{
            output$Mainui<- renderUI({
              fluidPage(
                includeCSS("packagestyle.css"),
                
                HTML(
                  '
                        <div id="header">
                        <h1>家 庭 电 影 院</h1>
                        </div>
                        
                        <div id="horizon_nav">
                        <ul>
                          <li><a href="" title="MV" target="">主 页</a></li>
                          <li><a href="" title="MV" target="">电 影</a></li>
                          <li><a href="" title="MV" target="">电 视 剧</a></li>
                          <li><a href="" title="MV" target="">音 乐</a></li>
                          <li><a href="" title="MV" target="">照 片</a></li>
                        
                        </ul>
                        </div>
                       '
                ),#end of HTML
                
                tags$video(id="videoID", type = "video/mp4",src =sprintf("%s/%s",j,`i`),
                           controls="controls",poster="poster.JPG",
                           style="heigth:500px;width:500px;")
                
              )
              
            })
          })
        }
      )
    }
  )
  
  
  
  
  
}

shinyApp(ui, server)
