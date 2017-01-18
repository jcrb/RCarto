
# Transforme les chiffres en character et ajoute un 0 devant si le code INSEE de
# la commune fait moins de 5 caractères
# c est un vecteur de codes INSEE
# Le vecteur corrigé est renvoyé:
add0 <- function(x){
        x <- as.character(x)
        for(i in 1:length(x))
                if(nchar(x[i]) < 5) 
                        x[i] = paste0("0", x[i])
return(x)}

# AttributJoin
# Voir R et espace
# 
#Jointure utiisant la méthode match qui ne modifi pas l'ordre des lignes
Attrib.Join <- function(df, spdf, df.field, spdf.field){
        if(is.factor(spdf@data[ , spdf.field]) == TRUE){
                spdf@data[ , spdf.field] <- as.character(spdf@data[ , spdf.field])
        }
        
        if(is.factor(df[ , df.field]) == TRUE){
                df[ , df.field] <- as.character(df[ , df.field])
        }
        
        spdf@data <- data.frame(
                spdf@data, df[match(spdf@data[ , spdf.field], df[ , df.field]),]
        )
return(spdf)
}
