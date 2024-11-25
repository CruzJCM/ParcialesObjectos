class Lugar {
  const nombre

  method nombre_par() = nombre.length().even()
  method cumple_diversion()
  method es_divertido() = self.nombre_par() && self.cumple_diversion()
  method cumple_tranquilidad() 
  method es_tranquilo() = self.cumple_tranquilidad()
  method es_raro() = nombre.length() > 10 
}

class Ciudad inherits Lugar{
  var property cantidad_habitantes
  var property atracciones_turisticas
  var property decibeles
  
  override method cumple_diversion() = atracciones_turisticas.size() > 3 && cantidad_habitantes > 100000
  override method cumple_tranquilidad() = decibeles < 20
}

class Pueblo inherits Lugar{
  var property extension
  var property fundacion
  var property provincia

  method es_litoral() = ["entreRios","corrientes","misiones"].contains(provincia)
  override method cumple_diversion() = fundacion < 1800 || self.es_litoral()
  override method cumple_tranquilidad() = provincia == "laPampa"
}

class Balneario inherits Lugar{
  var property metros_promedio
  var property mar_peligroso
  var property hay_peatonal

  override method cumple_diversion() = metros_promedio > 300 && mar_peligroso
  override method cumple_tranquilidad() = !hay_peatonal
}

object preferenciaDiversion{
  method va_a_lugar(lugar) = lugar.es_divertido() 
}
object preferenciaTranquilidad{
  method va_a_lugar(lugar) = lugar.es_tranquilo() 
}
object preferenciaRaresa{
  method va_a_lugar(lugar) = lugar.es_raro() 
}
class PreferenciaVariada {
  const property preferencias
  method va_a_lugar(lugar) = preferencias.any({preferencia => preferencia.va_a_lugar(lugar)})
}

class Persona {
  var property preferencia
  var property presupuesto_maximo

  method va_de_vacaciones(lugar) = preferencia.va_a_lugar(lugar)
  method puede_pasar_lugares(tour) = tour.lugares().all({lugar => self.va_de_vacaciones(lugar)})
  method puede_pagar(monto_por_persona) = monto_por_persona <= presupuesto_maximo
}

class Tour {
  var property fecha_salida
  var property cantidad_personas_requerida
  var property lugares
  var property monto_por_persona
  const integrantes = []
  const lista_de_espera = []

  method cantidad_integrantes() = integrantes.length()
  method hay_lugar() = integrantes.length() < cantidad_personas_requerida
  method va_a_lugares(persona) = lugares.all({lugar => persona.va_a_lugar(lugar)})
  method estaConfirmado() = integrantes.size() < cantidad_personas_requerida 

  method validar_monto(persona) = if(!persona.puede_pagar(monto_por_persona)) throw new DomainException(message = "Usted esta dispuesto a pagar menos que " + monto_por_persona)

  method validar_preferencia(persona) = if(!self.va_a_lugares(persona)) throw new DomainException(message = "Algun lugar no lo elegiria")

  method agregar_persona(persona) {
    self.validar_monto(persona)
    self.validar_preferencia(persona)
    if(!self.hay_lugar()) {
      lista_de_espera.add(persona)
      throw new DomainException(message = "No hay lugar")
    }
    integrantes.add(persona)
  }

  method bajar_persona(persona) {
    integrantes.remove(persona)
    integrantes.add().first(lista_de_espera)
  }

  method esDeEsteAnio() = fecha_salida.year() == new Date().year()
  method montoTotal() = monto_por_persona * integrantes.size() 
}

object reporte {
    const tours = []

    method toursPendienteDeConfirmacion() =  tours.filter{tour => !tour.estaConfirmado()}
    method montoTotal() = self.toursDeAnioActual().sum{tour => tour.montoTotal()} 
     
    method toursDeAnioActual() = tours.filter{ tour => tour.esDeEsteAnio()} 
}