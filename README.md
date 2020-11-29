# PGR5601 eksamen

## Oppsett og versjoner
- **IDE:** Xcode 12.0 ved prosjektets start, 12.2 etter automatisk oppdatering
- **Programmeringsspråk:** Swift 5
- **iOS deployment target:** 14.1 ved oppstart, 14.2 etter automatisk oppdatering

## Redegjørelser/Forbehold
- En del av filene i dette prosjektet er laget ved hjelp av tutorials fra Youtube, eller fra Udemy kurs jeg har tatt i løpet av semesteret. I tilfeller hvor dette er gjort har jeg markert filen med kommentarer i toppen. Det kan imidlertid være filer som ikke er markert, men som er laget med eller er tungt inspirert av tutorials som ikke har blitt markert. Alle filene er skrevet av meg for dette prosjektet, ingenting er copy/pasted.

- Filen WeatherData ble generert i QuickTyype (app.quicktype.io). Denne filen ble i utgangspunktet generert av meg selv. Men etterhvert som jeg skulle ta i bruk mer av APIet og Coding Keys tok jeg i bruk QuickType.

- I oppgave 2: "Når man viser posisjonen sin, så skal værmeldingen på forsiden oppdateres med å gi værmelding for den lokasjonen". Dette har jeg løst ved å sende brukerens koordinater til tab viewet, som igjen tar disse med til forsiden når man går tilbake hit. Så per definisjon oppdateres ikke været på forsiden når man kommer tilbake til forsiden, ikke mens man er på kartet. Jeg følte at dette var den mest ryddige måten å gjøre det på.

- I oppgave 4 står det : "Viewet under kartet med bilde og long/lat skal være et custom view som definerer en delegate som gir den dataene". Jeg var her litt usikker på om dere tenkte at kartet skulle ta i bruk delegate metoder fra viewet under, eller om dere mente at viewet skulle ta i bruk delegate metoder. I og med at jeg allerede i oppgave 1 hadde implementert delegate pattern (fra WeatherManager) valgte jeg å kjøre på dette videre. Og gjorde det slik at kartet "sa ifra" til viewet når lokasjonen ble endret så viewet kjører delegate metodene fra WeatherManager.

- Jeg hadde ikke mulighet til å installere iPhone 4 simulator. Den minste enheten jeg har prøvd på er derfor iPod Touch 7 gen. Applikasjonen fungerer helt fint på denne skjermstørrelsen. 

## Known bugs
- Jeg hadde tidligere en bug med at Core Data prøvde å innserte nil. Denne feilen førte til krasj av appen men skjedde veldig tilfeldig og ikke på langt nær hver gang. Jeg overvåkte derfor hva som prøvde settes inn i Core Data og hva som ble hentet fra Core Data. Dette var aldr nil selv når feilen dukket opp. Jeg fant etterhvert ut at dette var et threading problem. Jeg satte derfor insert metoden til å kjøre async på bcakground thread og "tvingte" fetch fra Core Data over på main thread. Etter å ha gjort dette har jeg ikke klart å gjenskape problemet, skulle det imidlertid oppstå vil det hjelpe bare å kjøre appen på nytt til det går, evt reinstallere appen. Men som sagt, jeg har **ikke** klart å gjenskape denne feilen.

- Jeg var ganske tidlig ferdig med løsningen, så den har ligget urørt i hvertfall 14 dager. I denne perioden har Xcode oppdatert seg automatisk for meg (til 12.2), og simulatoren kjører på iOS 14.2 (som kom 18. november). Etter dette har jeg fått et problem med at første gang appen installeres vil det settes inn masse objekter i Core Data som kan vises i ukesvarslingen (duplikater av de 7 dagene). Det rare er at hvis appen avinstalleres og installeres på nytt er det borte. Bygger man appen en gang til (ikke reinstall) så er  feilen tilbake. Bygger man enda en gang (ikke reinstall) er den borte og holder seg borte. Problemet oppstår igjen når simulator har vært avslutte og startes på nytt. Jeg er 100% sikker på denne feilen ikke var der før oppdatering, og mistenker på bakgrunn av det og mønsteret på feilen at dette er et problem med Xcode eller simulator. 
    **OPPDATERING:** Dette ser ut til å ha vært en problem som kom av at loksajons metodene ble kalt to ganger etter installering. Dette medførte også at fetch metoden til APIet ble kalt to ganger, som igjen førte til at insertion og fetching i Core Data kjørte to ganger relativt raskt etter hverandre, dette førte til en feil med lagring til Core Data. Jeg la inn funksjonalitet for å lagre brukerens lokasjon i variabler, og sjekker at CLLocationDegrees ikke er like som disse før jeg kaller fetch. Dette har løst problemet og fetchen kjøres nå kun én gang. Jeg klarer ikke å skjønne hvorfor det ble sånn. Eller om det alltid har vært sånn uten at jeg har merket det, selvom dette virker rart all den tid det ble velidg tydelig når jeg kom tilbake til appen. Dette kan også ha bidratt til nil feilen jeg nevnte tidligere, men jeg klarer nå altså ikke å gjenskape noen av feilene.

- Jeg testet løsningen på en Mac hvor jeg har Xcode 11.6 med iOS target deployment target 13.6. Her må løsningen endres i stor grad for å kunne kjøres. Regn animasjon i ukesoversikt fungerer **ikke** på denne versjonen. 
