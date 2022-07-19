#curating a list of reactions and genes 
#for pathways from metacyc 
#provided the modelseed database

#packages used
install.packages("readr")
library("readr")
install.packages("data.table")
library("data.table")
#import modelseed data base

ModelSeed<-read_tsv("Database/ModelSeedreactions.tsv")
View((ModelSeed))

#subset all GSL reations
GSLreactions <- ModelSeed[ModelSeed$pathways %like% "glucosinolate", ]
View(GSLreactions)
dim(OK.GSLreactions)
#subset balanced reactions

#OK.GSLreactions <- GSLreactions[GSLreactions$status %like% "OK", ]

#remove obsolete reactions
OK.GSLreactions <- GSLreactions[GSLreactions$is_obsolete %like% "0", ]

View(OK.GSLreactions)

#import list of reactions that we want from Data

PathwayofInterest<- read.table("Data/All_GSL_reactions.txt",sep="\t", header = T)
i<-1
Reactionlist<-data.frame()
#begin for loop

#for every reaction in pathwayof interest 
for (i in 1:(dim(PathwayofInterest)[1]-1)) {
#find associated records

ReactionsofInterest<-GSLreactions[GSLreactions$aliases %like% PathwayofInterest[i,1], ]
#add the arabidopsis gene to the record
ReactionsofInterest[,23]<-PathwayofInterest$Genes.of.a.reaction[i]
ReactionsofInterest[,24]<-PathwayofInterest[i,1]
print(PathwayofInterest[i,1])
print(dim(ReactionsofInterest)[1])
#rbind to data frame
Reactionlist<-rbind(Reactionlist,ReactionsofInterest)
#end loop 
}
View(Reactionlist)


#export for manual curation?

write.csv( Reactionlist,"Output/Reactionlist.csv")


#on the outside use judegement to reduce to the number of reactions necessary 
#eg. 18 reactions in the pathways but 24 are returned means 6 need to be dropped


