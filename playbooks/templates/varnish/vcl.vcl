# 4.0 formaat
vcl 4.0;

#Varnish Mods Importeren
import directors;
import saintmode;

#whitelist van aanvragers

#hello-app whitelist
acl whitelist1 {
	"172.16.1.39";
	"localhost";
	"127.0.0.1";
}
#postcode whitelist
acl whitelist2 {
	"172.16.1.40";
	"localhost";
	"127.0.0.1";
}
#admin whitelist
acl whitelist3 {
	"172.16.1.41";
	"localhost";
	"127.0.0.1";
}

#De backend servers

#helloapp
backend ws1 {
    .host = "192.168.10.21";
    .port ="5000";
}
#helloapp
backend ws2 {
    .host = "192.168.10.22";
    .port ="5000";
}
#helloapp-backup
backend ws3 {
    .host = "192.168.10.23";
    .port ="5000";
}
#postcodeapp
backend ws4 {
    .host = "192.168.10.24";
    .port ="5000";
}
Admin website
backend ws5 {
    .host = "192.168.10.25";
    .port ="80";
}

sub vcl_init {
	    # roundrobin backand een en twee koppelen
	    new round_robin_director = directors.round_robin();
	    round_robin_director.add_backend(ws1);
	    round_robin_director.add_backend(ws2);
	
	    # verdeling tussen servers aanpassen
	    new random_director = directors.random();
	    random_director.add_backend(ws1, 1 );
	    random_director.add_backend(ws2, 1 );
	
	    # backup, saintmode instellen
	    new sm1 = saintmode.saintmode(random_director, 5);
	    new sm1 = saintmode.saintmode(ws3 ,5);
	    # saintmode clusteren voor fallback
	    new fb = directors.fallback() ;
	    fb.add_backend(ws3(10)) ;	
}

#Filters op aanvragen
sub vcl_recv
{
	#Is er wel een token?
	if (!req.http.token){
		return (synth (403, Onbevoegd zonder token));
	}

	if (req.http.token == 1234){
		
	}

	if (req.http.token == 5555){
		
	} 

	if (req.http.token == 1234){
		
	}

	#redirect index naar /	
	if (req.url ~ "^/index.php" ){
		return (synth (750, "/")); }
	#plaatjes mogen door
	if (req.url ~ "\.(jpg|jpeg|css|js)$"){
		return (hash) ;}

        #hallo python
        if (req.url ~ "^/hello" || req.url ~ "^/sleep"){
                set req.backend_hint = hello;
                return (hash);
	}

        # Admin toegang en alle servers
	if  (client.ip == "192.168.0.193" /* || client.ip ==  "127.0.0.1" */) {
	   	# Algemene toegang maar niet cachen
	    	if (req.url ~ "^/admin.php" || req.url ~ "^/lot_aanvraag.php" ) {
	       		 return (pass);
		}
		# aanvragen worden doorgestuurd naar webserver two
		if (req.url ~ "^/postcode.php") {
			set req.backend_hint = two;
			return (hash);
		}
		# de loadbalanced website wordt accepted en via loadbalncing
		if (req.url ~ "^/lb.html" ){
			 set req.backend_hint = round_robin_director.backend();
                       return (hash);
		}
		#normale toegang
		if (req.url == "/" || req.url ~ "^/welkom.php" || req.url ~ "^/prijs.php" || req.url ~ "^/prijskoppel.php" ){
			return (hash);
		}
		else {
            		return (synth (403));
   		} 
	  /*
	    # De servers worden naar one gestuurd en naar fallback indien nodig
	    set req.backend_hint= fb.backend() ;
	  */
  	  
        }

	# Server authenticatie gebruikers groep 1
	if (client.ip == "192.168.0.198"){
		#token authenticatie  9999
		if (req.http.token == "9999"){	
			# aanvragen worden doorgestuurd naar webserver one
			if (req.url == "/" || req.url ~ "^/index.php" || req.url ~ "^/welkom.php") {
				set req.backend_hint = one;
				return (hash);
			}
			# aanvragen worden doorgestuurd naar webserver two
			if (req.url ~ "^/postcode.php"){
				set req.backend_hint = two;
				return (hash);
			}
			# aanvragen worden loadbalanst doorgestuurd naar one en two
			if (req.url ~ "^/lb.html" ){
				set req.backend_hint = round_robin_director.backend();
				return (hash);
                	}
			else{
	 		       	return (synth (403) );
			}
        	}		
       		#token autenticatie 2222
		if (req.http.token == "2222"){
			if (req.url == "/" || req.url ~ "^/index.php") {
				return (hash); }
			else{
				return (synth (403) );
			}
		}
		else{
			return (synth (403, "Geen toegangscode") );
		}
        }
	else {  
		return (synth (403, "je mag hier niet kijken") );
	}
}

sub vcl_synth {
	if (resp.status == 750) {
		set resp.http.location = resp.reason;
		set resp.status = 301;
		return(deliver);
	}

}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.

    # cachet op 1 minuut
    set beresp.ttl = 1m;
    set beresp.grace = 1m;
    # Regelt cache in het geval de pagina niet gevonden is (error 404).
    if (beresp.status == 404) {
       set beresp.ttl = 10s; }
/* 
   # bij foutmelding 50x stoppen met cache (uitzetten als saintmode)
   if (beresp.status >= 500 || beresp.status <= 505) {
      set beresp.ttl = 1s;
      return (abandon); }
*/
    # Hoofdpagina moet vaak geupdate worden.
    if (bereq.url ~ "^/" || bereq.url ~ "^/index.php" ) {
        set beresp.ttl = 10s; } 

    # plaatjes van indexpage.
    if (bereq.url ~ "hoofdpagina.jpg$")  {
	set beresp.ttl = 1h; }
        #plaatjes van welkom.
    if (bereq.url !~ "hoofdpagina.jpg$" && bereq.url ~ "\.jpg$")  {
	set beresp.ttl = 1w; }

	#ESI van index toevoegen
    if (bereq.url == "index.php") {
        set beresp.do_esi = true;}
    elsif (bereq.url == "nieuws.php") {
	set beresp.ttl = 1m; }
/*
    # saintmode fallback instellen
    if (beresp.status >= 500) {
       saintmode.blacklist(10s);
       return (retry); }
*/      
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object her
	   set resp.http.X-Cache-Hits = obj.hits;
 
}
