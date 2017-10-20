'use strict'
var mysql = require('mysql');
var fetch = require('node-fetch');
const http = require('http')
const url = require('url')
const host = process.env.HOST || '127.0.0.1'     // arduino address is 192.168.1.90
const port = process.env.PORT || 8080
const qs = require('querystring')
const addressArduino = '192.168.1.90';
// --- Datos de la conexion 
var connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'xyz789',
    database: 'Arduino1',
    port: 3306
});

//--- Hacer peticion al servidor de arduino cada x tiempo
var sync1 =  setInterval(function(){
     console.log('Hacer peticion');
     fetch(addressArduino).then(function(res) {
        return res.json();
     }).then(function(json) {
        fnInsert(json);
    });
}, 1000);     // Cada n milisegundos ejecuta la fn anonima


//--- Hacer peticion al servidor de arduino cada x tiempo
var sync2 =  setInterval(function(){
    console.log('Hacer peticion');
    fetch('http://smn.cna.gob.mx/webservices/index.php?method=1').then(function(res) {
        return res.json();
    }).then(function(json) {
        fnInsertMet(json);
    });
}, 1000);     // Cada n milisegundos ejecuta la fn anonima


var sync3 =  setInterval(function(){
     console.log('Hacer peticion');
     fnSelect();
}, 1000);     // Cada n milisegundos ejecuta la fn anonima

function fnSelect() {
   var Consulta=connection.query('SELECT * FROM arduinoguardar',function (error,result) {
       if(error){
           throw error;
       }else{
           var resultado=result;
           var Hileras = resultado.length;

           if (Hileras > 0){
               fnEncender(resutado[ultimo-1]);  // envia datos del ultimo registro, i.e. el estado del arduino
           } else {
               console.log("no lo encontramos");
           }
       }
   });
} // fn

function fnEncender(jsonEdo) {
   if( jsonEdo.humedad <= 50 && jsonEdo.iluminacion < 70 && jsonEdo.temperatura < 30  && fnisRain()<80) {
       fetch(addressArduino+"/encender/1");    // pide a Arduino que encienda la bomba de agua
   }  
} // fn

function fnisRain()
{
    var Consulta=connection.query('SELECT * FROM meteorologia',function (error,result) {
        if(error){
            throw error;
        }else{
            var resultado=result;
            var Hileras = resultado.length;

            if (Hileras > 0){
                return(resutado[ultimo-1]);  // envia datos del ultimo registro, i.e. el estado del arduino
            } else {
                console.log("no lo encontramos");
                return(0);

            }
        }
    });
}

function fnInsert(json) {
   connection.connect(function(error){
       if(error){
           throw error;
       }else{
           console.log('Conexion correcta.');
       }
   }); // connect
   var query = connection.query(
       'INSERT INTO arduinoguardar(iluminacion,temperatura,humedad) VALUES(?,?,?)',[json.iluminacion,json.temperatura,json.humedad], function(error, result){
           if(error){
               throw error;
           }else{
               console.log(result);
           }
       }
   );
    function fnInsertMet(ProbabilityOfPrecip) {
        connection.connect(function(error){
            if(error){
                throw error;
            }else{
                console.log('Conexion correcta.');
            }
        }); // connect
        var query = connection.query(
            'INSERT INTO meteorologia(probLluvia) VALUES(?)',[ProbabilityOfPrecip], function(error, result){
                if(error){
                    throw error;
                }else{
                    console.log(result);
                }
            }
        );


   // query
   connection.end();
} // fn


/* ====
  *  Un server para mostrar los datos de la base de datos
  * ====

const server = http.createServer((req, res) => {
  if (req.method !== 'GET') return error(res, 405)
  if (req.url === '/') return fnIndex(res)
  // --- Pathname es la ruta y query son los parametros de forma ?data=valor
  const {pathname, query} = url.parse(req.url)
  if (pathname === '/users')  return 0;   //host:port?users, query es la lista de parametros, o sea lo que sigue luego de ?
  error(res, 404)
})

function error (res, code) {
  res.statusCode = code
  res.end(`{"error": "${http.STATUS_CODES[code]}"}`)
}

function fnIndex (res) {
  res.end('{"name": "my-rest-server", "version": 0}')
}

console.log("Listen on " + host + ":" + port);
server.listen(port, host)
 */