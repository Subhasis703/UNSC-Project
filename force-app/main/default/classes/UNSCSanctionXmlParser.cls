public with sharing class UNSCSanctionXmlParser {
      list<SanctionedList__c> sanclist = new list<SanctionedList__c>();
      list<alias__c> alias_list = new list<alias__c>();
      SanctionedList__c sancrec = new SanctionedList__c();
      Alias__c  alias_rec = new Alias__c();
      Integer i = 1;
      public void parseResponseDom(string Url) {
        // this method is called from apex scheduler scheduleUNSCSanctionXmlParser
        http h = new http();
        HttpRequest req = new HttpRequest();
        // url that returns the XML in the response body 
          req.setEndpoint(Url);
          req.setMethod('GET');
          HttpResponse res = h.send(req);
          Dom.Document doc = res.getBodyDocument();
      //Retrieve the root element for this document.
      try {
            Dom.XmlNode rootNode = doc.getRootElement();
            parseXML(rootNode);
            system.debug('total insert in sanclist:'+ sanclist.size());
            system.debug('total insert in aliaslist:'+ alias_list.size());
           /* system.debug(alias_list.get(15));
            system.debug(alias_list.get(51));*/
           // insert sanclist;
           
           database.insert(sanclist,false); 
         /*  for(i=0; i <= alias_list.size(); i++){
             system.debug('alias rec'+ alias_list.get(0));
           }
           database.insert(alias_list,false); */
      }
       catch(Exception e) {
           System.debug(e.getCause());
           system.debug(e.getLineNumber());
           system.debug(e.getStackTraceString());
           System.debug(e.getMessage());
       }
     }
       
    public void parseXML(DOM.XMLNode node) {
     //  system.debug('iteration no:' + i);
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
        if (node.getName()=='INDIVIDUAL'|| node.getName()=='ENTITY') {
           sancrec.Type__c = node.getName(); 
           system.debug('node type:' + sancrec.Type__c);
           If (sancrec!=NULL && node.getName()=='INDIVIDUAL') {
             sanclist.add(new SanctionedList__c(Name = sancrec.name,REFERENCE_NUMBER__c = sancrec.REFERENCE_NUMBER__c,
             SECOND_NAME__c = sancrec.SECOND_NAME__c,
             THIRD_NAME__c  = sancrec.THIRD_NAME__c,
             FOURTH_NAME__c = sancrec.FOURTH_NAME__c,
             UNLIST_TYPE__c = sancrec.UNLIST_TYPE__c,
             NATIONALITY__c = sancrec.NATIONALITY__c,
             INDIVIDUAL_DATE_OF_BIRTH__c = sancrec.INDIVIDUAL_DATE_OF_BIRTH__c,
             INDIVIDUAL_DOCUMENT_NUMBER__c = sancrec.INDIVIDUAL_DOCUMENT_NUMBER__c,
             INDIVIDUAL_DOCUMENT_TYPE__c =   sancrec.INDIVIDUAL_DOCUMENT_TYPE__c,
             COMMENTS1__c = sancrec.COMMENTS1__c,
             Type__c = sancrec.Type__c,
             CITY_OF_BIRTH__c = sancrec.CITY_OF_BIRTH__c,
             COUNTRY_OF_BIRTH__c = sancrec.COUNTRY_OF_BIRTH__c,
             INDIVIDUAL_ADDRESS__c = sancrec.INDIVIDUAL_ADDRESS__c,
             LISTED_ON__c = sancrec.LISTED_ON__c  ));
          }
          If (sancrec!=NULL && node.getName()=='ENTITY') {
             sanclist.add(new SanctionedList__c(Name = sancrec.name,REFERENCE_NUMBER__c = sancrec.REFERENCE_NUMBER__c,
             UNLIST_TYPE__c = sancrec.UNLIST_TYPE__c,
             COMMENTS1__c = sancrec.COMMENTS1__c,
             Type__c = sancrec.Type__c,
             LISTED_ON__c = sancrec.LISTED_ON__c  ));
          }
              // add alias record as well
              if (alias_rec.name!=NULL && alias_rec.QUALITY__c!=NULL ){
              system.debug('adding alias record if any');
              system.debug('ORIGINAL NAME:' + sancrec.name);
              system.debug('ALIAS NAME:' + alias_rec.name );
              System.debug('quality:'+ alias_rec.QUALITY__c );
              /*alias_list.add(new Alias__c(Name = alias_rec.name,
                                            	original_name__c = sancrec.id,
                                              QUALITY__c = alias_rec.QUALITY__c,
                                              Date_of_Birth__c = alias_rec.Date_of_Birth__c,
                                              City_of_Birth__c = alias_rec.City_of_Birth__c,
                                              Country_of_Birth__c = alias_rec.Country_of_Birth__c
                                              ));*/
              }
              // create a new obj when node INDIVIDUAL is parsed
              // SanctionedList__c sancrec = new SanctionedList__c();
               system.debug('current list size' + sanclist.size());
               system.debug('iteration no:' + i);
               system.debug('CHECKING INDIVIDUAL OR ENTITY NODE' );
           }   
        if(node.getName()=='REFERENCE_NUMBER')
               {
                  sancrec.REFERENCE_NUMBER__c = node.getText().trim();
                  system.debug('REFERENCE_NUMBER assigned:' + sancrec.REFERENCE_NUMBER__c );
               }
                  
            if(node.getName()=='FIRST_NAME') {
               sancrec.Name = node.getText().trim();
               system.debug('first NAME assigned:' + sancrec.name);
            }
            
            if(node.getname()=='SECOND_NAME') {
             sancrec.SECOND_NAME__c = node.getText().trim(); 
             system.debug('second NAME assigned:' + sancrec.SECOND_NAME__c);
           }
           if(node.getname()=='THIRD_NAME') {
             sancrec.THIRD_NAME__c = node.getText().trim(); 
             system.debug('third NAME assigned:' + sancrec.THIRD_NAME__c);
           }
           if(node.getname()=='FOURTH_NAME') {
             sancrec.FOURTH_NAME__c = node.getText().trim(); 
           }
           if(node.getname()=='COMMENTS1') {
             sancrec.COMMENTS1__c = node.getText().trim(); 
             system.debug('comment:' + sancrec.COMMENTS1__c);
           }
           if(node.getname()=='NATIONALITY') {
             sancrec.NATIONALITY__c = node.getChildren().get(0).getText().trim(); 
             system.debug('Nationality:' + sancrec.NATIONALITY__c);
           }    
          /* if(node.getname()=='INDIVIDUAL_PLACE_OF_BIRTH') {
             sancrec.CITY_OF_BIRTH__c    = node.getChildren().get(0).getText().trim(); 
             sancrec.COUNTRY_OF_BIRTH__c = node.getChildren().get(1).getText().trim(); 
             system.debug('city:' + sancrec.CITY_OF_BIRTH__c);
             system.debug('country:' + sancrec.COUNTRY_OF_BIRTH__c);
           }
           if(node.getname()=='INDIVIDUAL_ADDRESS') {
             sancrec.INDIVIDUAL_ADDRESS__c = node.getChildren().get(0).getText().trim() +
                                             node.getChildren().get(1).getText().trim() +
                                             node.getChildren().get(2).getText().trim() +
                                             node.getChildren().get(3).getText().trim() +
                                             node.getChildren().get(4).getText().trim();   
            system.debug('address' + sancrec.INDIVIDUAL_ADDRESS__c );  
           } */
           if(node.getname()=='TYPE_OF_DOCUMENT' && string.isNotBlank(node.getText())) {
             sancrec.INDIVIDUAL_DOCUMENT_TYPE__c = node.getText().trim(); 
             system.debug('type of doc:' + sancrec.INDIVIDUAL_DOCUMENT_TYPE__c);
           }  
            if(node.getname()=='NUMBER') {
             sancrec.INDIVIDUAL_DOCUMENT_NUMBER__c = node.getText().trim(); 
             system.debug('document number:' + sancrec.INDIVIDUAL_DOCUMENT_NUMBER__c);
           }     
           if(node.getname()=='DATE') {
             sancrec.INDIVIDUAL_DATE_OF_BIRTH__c = date.valueOf(node.getText().trim());
           }    
           if(node.getname()=='UN_LIST_TYPE') {
             sancrec.UNLIST_TYPE__c = node.getText().trim(); 
             system.debug('UN LIST TYPE:' + sancrec.UNLIST_TYPE__c );
           } 
           if(node.getname()=='LISTED_ON') {
             sancrec.LISTED_ON__c = date.valueOf(node.getText().trim()); 
           }
          
           if(node.getname()=='INDIVIDUAL_ALIAS'|| node.getname() =='ENTITY_ALIAS'){
            /* if (alias_rec.name!=NULL && alias_rec.QUALITY__c!=NULL && node.getname()=='INDIVIDUAL_ALIAS' ){
              system.debug('IN ALIAS LOOP: ORIGINAL NAME:' + sancrec.name);
              system.debug('ALIAS NAME:' + alias_rec.name );
              System.debug('quality:'+ alias_rec.QUALITY__c );
              alias_list.add(new Alias__c(Name = alias_rec.name,
                                            	original_name__c = sancrec.name,
                                              QUALITY__c = alias_rec.QUALITY__c,
                                              Date_of_Birth__c = alias_rec.Date_of_Birth__c,
                                              City_of_Birth__c = alias_rec.City_of_Birth__c,
                                              Country_of_Birth__c = alias_rec.Country_of_Birth__c
                                              ));
             }
             if (alias_rec.name!=NULL && alias_rec.QUALITY__c!=NULL && node.getname()=='ENTITY_ALIAS' ){
              alias_list.add(new Alias__c(Name = alias_rec.name,
                                            	original_name__r = (string)sancrec.name,
                                              QUALITY__c = alias_rec.QUALITY__c ));                                
             }*/ 
             //crete new alias record
             alias__c alias_rec = new Alias__c(); 
           }
            if(node.getname() =='QUALITY' && string.isNotBlank(node.getText())) {
                   alias_rec.QUALITY__c = node.getText().trim();
                   system.debug('QUALITY:' + alias_rec.QUALITY__c );
           } 
               
                 if(node.getName() == 'ALIAS_NAME' && string.isNotBlank(node.getText())) {
                   alias_rec.name = node.getText().trim();
                   system.debug('ALIAS NAME:' + alias_rec.name );
                 }
                /* if(node.getName() == 'DATE_OF_BIRTH') {
                   alias_rec.Date_of_Birth__c = date.valueOf(node.getText().trim());
                   system.debug('DOB:' + alias_rec.Date_of_Birth__c );
                 }*/
                 if(node.getName() == 'CITY_OF_BIRTH' && string.isNotBlank(node.getText())) {
                   alias_rec.City_of_Birth__c = node.getText().trim();
                   system.debug('COB:' + alias_rec.City_of_Birth__c );
                 }
               }
       //calling parseXML recursively to process child elements
        for (Dom.XMLNode child: node.getChildElements()) {
            system.debug(child.getName());
            i = i + 1; 
            parseXML(child); 
        }
    }  
}