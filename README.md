# equifax_tmdb

This is the Equifax test

## Getting Started
para comenzar solo hay que hacer un flutter pub get ya que agrege las dependencias de:
  http: ^1.2.2
  carousel_slider: ^5.0.0
  provider: ^6.1.2
  shared_preferences: ^2.3.5

En mi maquina local se esta trabajando con la versión ...
environment:
  sdk: ^3.5.4

Del framework Flutter(no deberia existir problemas)

Estructura del proyecto:

    En esta parte de la prueba luego de leer y comprender el desafio existente tome la desición de usar un enfoque simple con provider como lo recomienda la documentacion de Flutter,dentro de esta clase provider que mixie con Changenotifier, defini los metodos htttp que hablaran con la api de The Movie DB, defini las rutas necesarias para lo solicitado y fui descubriendo varias cosas que explicare mas adelante.

    primero que nada en la pantalla inicial o clase: homepage archivo movies_page.dart, utilice el metodo of de provider para acceder al contexto y asi acceder al provider, luego para usarlo declare en la clase main el multiprovider con los nombres de los providers que estaran gestionando el estado de la app, en este caso solo 1, despues de esto como el arbol de widgets ya sabe de la existencia de este provider lo declare con: 

        final movieProvider = Provider.of<APIProvider>(context).getPopular();
    
    para poder utilizarlo con el widget FutureBuilder y asi acceder a la data 

    En la pantalla de detalles utilice el enfoque de utilizar el objeto seleccionado en la pantalla home pasandolo por la ruta de navegacion en:

        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => MovieDetailPage(
                movie: movie,
            ),
            ),
        );
    
    Sin embargo en esta pantalla tambien utilice el gestor provider para acceder al estado de la app, en este caso defini el provider con:

        final apiProvider = Provider.of<APIProvider>(context);
    
    Para que pueda ser consumido por un FutureBuilder 

    En la pantalla de lista de vistos utilice un enfoque dirigido por SharedPreferences, que es el lugar donde se esta almacenando cada pelicula que el usuario seleccione como vista en cuanto al diseño de la aplicación, me ayude por la documentacion e IA. de la siguiente forma se accede a los datos de shared preferences

        final prefs = await SharedPreferences.getInstance();

    En cuanto a lo que me falto, intente agregar un buscador aunque no lo consegui ya que personalmente tenia un enfoque estructurado al uso de servicios conectados a una base de datos, tambien el boton load more, lo utilizaria con un enfoque dirigido al uso de base de datos, llamando a un servicio, creo que no me falta nada mas que agregar.


En caso de tener dudas me puede encontrar en el wsp:

    +56985896804
    christianmosa123321@gmail.com
