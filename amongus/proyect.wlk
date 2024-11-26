class Jugador {
  var property color
  const mochila = []
  var property nivel_de_sospecha = 40
  const property tareas = #{}
  var esta_impugnado = false
  var expulsado = false

  method es_sospechoso() = nivel_de_sospecha > 50
  method es_impostor() 

  method busca_item(item) {
    mochila.add(item)
  }
   method usar_item(item) {
    mochila.remove(item)
  }
  method tiene_items(items) = items.all({item => mochila.contains(item)})

  method aumentar_sospecha(valor) {
    nivel_de_sospecha += valor
  }
  method disminuir_sospecha(valor) {
    nivel_de_sospecha -= valor
  }

  method completo_todas_tareas()

  method realizar_tarea(tarea) {}

  method impugnado() {
    esta_impugnado = true
  }

  method llamar_emergencia() {
    nave.emergencia()
  }
  method votar_blanco() {}
  method votar_jugador(jugadores) {}
  method votar(jugadores) {
    if (esta_impugnado) {
        esta_impugnado = false
        self.votar_blanco()
    } else{
        self.votar_jugador(jugadores)
    }
  }
}



class Tripulante inherits Jugador{
  const property criterio
  var property jugador_votado 
  override method completo_todas_tareas() = tareas.isEmpty()

  method obtener_tarea_realizable() = tareas.find({tarea => tarea.puede_realizarce_por(self)})

  override method realizar_tarea(tarea) {
    if(self.tiene_items(tarea.items_necesarios())){
        tarea.items_necesarios().forEach({item => self.usar_item(item)})
        tarea.efecto()
    }
  }
  override method votar_blanco() {
    nave.votos().add(votoEnBlanco)
  }
  override method votar_jugador(jugadores) {
    jugador_votado = criterio.votacion(jugadores)
    nave.votos().add(jugador_votado)
  }
}
class Impostor inherits Jugador {
  override method completo_todas_tareas() = true
  method realizar_sabotaje(sabotaje) {
    sabotaje.efecto(self)
  }
}

class Item {}
const escoba = new Item()
const llaveInglesa = new Item()
const bolsaConsorcio = new Item()

class Tarea {
  const items_necesarios = []
  method puede_realizarce_por(jugador) = jugador.tiene_items(items_necesarios)
}

object arreglarTablero inherits Tarea(items_necesarios=[llaveInglesa]) {
  method efecto(tripulante) {
    if(tripulante.tiene_items(items_necesarios)) tripulante.aumentar_sospecha(10)
  }
}
object sacarBasura inherits Tarea(items_necesarios=[escoba,bolsaConsorcio]) {
  method efecto(tripulante) {
    if(tripulante.tiene_items(items_necesarios)) tripulante.disminuir_sospecha(4)
  }
}
object ventilarNave inherits Tarea {
  method efecto(tripulante) {
    nave.aumentar_oxigeno(5)
  }
}

object sabotearOxigeno {
  method efecto(impostor) {
    nave.disminuir_oxigeno(10)
    impostor.aumentar_sospecha(5)
  }
}
class ImpugnarJugador {
  var property jugador
  method efecto(impostor) {
    jugador.impugnado()
    impostor.aumentar_sospecha(5)
  }
}

object nave {
  const jugadores = []
  const property votos = #{}
  var property nivel_oxigeno = 100
  var cantidad_tripulantes = 8
  var cantidad_impostores = 2

  method aumentar_oxigeno(valor) {
    nivel_oxigeno += valor
  }
  method disminuir_oxigeno(valor) {
    nivel_oxigeno -= valor
        if(self.nivel_oxigeno() <= 0) throw new DomainException(message = "Ganaron los impostores")

  }

  method ganan_tripulantes() = jugadores.all({jugador => jugador.completo_todas_tareas()})
  method informar_victoria_tripulantes() {
    if(self.ganan_tripulantes()) throw new DomainException(message = "Ganaron los tripulantes")
  }

  method iniciar_votacion() {
    jugadores.forEach({jugador => jugador.votar()})
  }
  method emergencia() {
    self.iniciar_votacion()
    self.expulsar_jugador_votado()
  }
  method expulsar_jugador_votado() {
    //hacer algo que expulse al que aparecio mas veces
    //jugadores.remove(jugador_votado)
    //jugador.expulsado(true)
    if(cantidad_impostores == cantidad_tripulantes) throw new DomainException(message = "Ganaron los impostores")
    if(cantidad_impostores == 0) throw new DomainException(message = "Ganaron los tripulantes")
  }
}

object criterioTroll {
  method votacion(jugadores) = jugadores.findOrElse({jugador => jugador.nivel_de_sospecha() == 0}, votoEnBlanco)
}
object criterioDetective {
  method votacion(jugadores) = jugadores.max({jugador => jugador.nivelSospecha()})
}
object criterioMaterialista {
  method votacion(jugadores) = jugadores.findOrElse({jugador => jugador.mochila().isEmpty()}, votoEnBlanco)
}

object votoEnBlanco {}