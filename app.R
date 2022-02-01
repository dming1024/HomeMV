
#a videos list on shiny
#setwd("D:\\shiny\\shinyVideos")
#不预先加载电影，点击按钮后，再去加载电影
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
  
  
  moveName<-reactive({
    mvNames=list.files("www",pattern = "*.mp4")
    return(mvNames)
  })
  
  AddmvButton<-function(moveName){
    ui=tags$div(
      id="videos",
      actionButton(
        inputId=sprintf("%s",moveName),
        label = HTML(sprintf("%s",ifelse( stringr::str_length(moveName)>30,
                                     gsub("\\n","<br/>",stringr::str_wrap(stringr::str_sub(moveName,1,30),20)),
                                     gsub("\\n","<br/>",stringr::str_wrap(moveName,20))))),
        width = "100%",
        icon("far fa-play-circle"),
        style="height: 80px;background-color: #FFF8DC;"
      ),
      #tags$p(id="description",sprintf("%s",moveName)),
      style="padding:4px 5px 5px 5px;border:5px solid #FFFFFF;border-radius:25px;heigth:120px;width:220px;float:left"
    )
    return(ui)
  }
  
  AddmvFunction<-function(moveName){
    ui=tags$div(
      id="videos",
      tags$video(id="videoID", type = "video/mp4",src =sprintf("%s",moveName) ,
                 controls="controls",poster="poster.JPG",
                 style="heigth:100px;width:200px;"),
      tags$p(id="description",sprintf("%s",moveName)),
      style="padding:4px 5px 5px 5px;border:5px solid #FFFFFF;border-radius:25px;heigth:120px;width:220px;float:left"
    )
    return(ui)
  }
  
  #设置每页展示的条目
  perPage<<- 10
  currentPage<<- 1
  
  #总过有多少页
  TotalPages<<- reactive({
    TotalPages=ceiling(length(moveName())/perPage)
    return(TotalPages)
  })
 

    
  
  #第一页
  observeEvent(input$home,
               {
                 currentPage<<- 1
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
                          <li><a href="" title="MV" target="">电 影</a></li>
                          <li><a href="" title="MV" target="">电 视 剧</a></li>
                          <li><a href="" title="MV" target="">音 乐</a></li>
                          <li><a href="" title="MV" target="">照 片</a></li>
                        
                        </ul>
                        </div>
'
                     ),#end of HTML
                     tags$div(
                       id="allMovies",
                       lapply(moveName()[1:perPage],AddmvButton),
                       style="float:left;"
                     ),
                     tags$div(
                       id="Buttons",
                       actionButton("home","HOME"),
                       actionButton("Forward","<<"),
                       actionButton('Reverse',">>"),
                       actionButton("end","END"),
                       style="border:5px solid #FFFFFF;border-radius:10px;text-align:center;"
                     )
                   )
                   
                 })
                 
               }
  )
  
  #最后一页
  observeEvent(input$end,
               {
                 
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
                          <li><a href="" title="MV" target="">电 影</a></li>
                          <li><a href="" title="MV" target="">电 视 剧</a></li>
                          <li><a href="" title="MV" target="">音 乐</a></li>
                          <li><a href="" title="MV" target="">照 片</a></li>
                        
                        </ul>
                        </div>
'
                     ),#end of HTML
                     tags$div(
                       id="allMovies",
                       lapply(moveName()[((TotalPages()-1)*perPage+1):length(moveName())],AddmvButton),
                       style="float:left;"
                     ),
                     tags$div(
                       id="Buttons",
                       actionButton("home","HOME"),
                       actionButton("Forward","<<"),
                       actionButton('Reverse',">>"),
                       actionButton("end","END"),
                       style="border:5px solid #FFFFFF;border-radius:10px;text-align:center;"
                     )
                   )
                   
                 })
                 
               }
  )
  
  #后退
  observeEvent(input$Reverse,
               {
                 currentPage<<- ifelse(currentPage<TotalPages(),currentPage+1,TotalPages())
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
                          <li><a href="" title="MV" target="">电 影</a></li>
                          <li><a href="" title="MV" target="">电 视 剧</a></li>
                          <li><a href="" title="MV" target="">音 乐</a></li>
                          <li><a href="" title="MV" target="">照 片</a></li>
                        
                        </ul>
                        </div>
                       '
                     ),#end of HTML
                     if(currentPage==TotalPages()){
                       #最后一页了
                       tags$div(
                         id="allMovies",
                         lapply(moveName()[((currentPage-1)*perPage+1):(length(moveName()))],AddmvButton),
                         style="float:left;"
                       )
                     }else{
                       tags$div(
                         id="allMovies",
                         lapply(moveName()[((currentPage-1)*perPage+1):(currentPage*perPage)],AddmvButton),
                         style="float:left;"
                       )
                     },
                     
                     tags$div(
                       id="Buttons",
                       actionButton("home","HOME"),
                       actionButton("Forward","<<"),
                       actionButton('Reverse',">>"),
                       actionButton("end","END"),
                       style="border:5px solid #FFFFFF;border-radius:10px;text-align:center;"
                     )
                   )
                   
                 })
                 
               }
  )
  
  #前进
  observeEvent(input$Forward,
               {
                 currentPage<<- ifelse(currentPage>1,currentPage-1,1)
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
                          <li><a href="" title="MV" target="">电 影</a></li>
                          <li><a href="" title="MV" target="">电 视 剧</a></li>
                          <li><a href="" title="MV" target="">音 乐</a></li>
                          <li><a href="" title="MV" target="">照 片</a></li>
                        
                        </ul>
                        </div>
                       '
                     ),#end of HTML
                     tags$div(
                       id="allMovies",
                       lapply(moveName()[((currentPage-1)*perPage+1):(currentPage*perPage)],AddmvButton),
                       style="float:left;"
                     ),
                     tags$div(
                       id="Buttons",
                       actionButton("home","HOME"),
                       actionButton("Forward","<<"),
                       actionButton('Reverse',">>"),
                       actionButton("end","END"),
                       style="border:5px solid #FFFFFF;border-radius:10px;text-align:center;"
                     )
                   )
                   
                 })
                 
               }
  )
  
  
  
  
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
  <li><a href="" title="MV" target="">电 影</a></li>
  <li><a href="" title="MV" target="">电 视 剧</a></li>
  <li><a href="" title="MV" target="">音 乐</a></li>
  <li><a href="" title="MV" target="">照 片</a></li>

</ul>
</div>
'
      ),#end of HTML
      tags$div(
        id="allMovies",
        lapply(moveName()[1:perPage],AddmvButton),
        style="float:left;"
      ),
      tags$div(
        id="Buttons",
        actionButton("home","HOME"),
        actionButton("Forward","<<"),
        actionButton('Reverse',">>"),
        actionButton("end","END"),
        style="border:5px solid #FFFFFF;border-radius:10px;text-align:center;"
      )
    )
    
  })
  
#  output$test<-renderText(
#      {
#       moveName()
#      }
#    )
  

  
  #播放MV,当一旦observe event事件出现后
  lapply(
    X=list.files("www",pattern = "*.mp4"),
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
            
            tags$video(id="videoID", type = "video/mp4",src =sprintf("%s",`i`),
                       controls="controls",poster="poster.JPG",
                       style="heigth:500px;width:500px;")
            
          )
          
        })
      })
    }
  )
  

}

shinyApp(ui, server)
