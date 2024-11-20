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

const laPampa = object {}
const entreRios = object {}
const corrientes = object {}
const misiones = object {}

class Pueblo inherits Lugar{
  var property extension
  var property fundacion
  var property provincia

  method es_litoral() = [entreRios,corrientes,misiones].contains(provincia)
  override method cumple_diversion() = fundacion < 1800 || self.es_litoral()
  override method cumple_tranquilidad() = provincia == laPampa
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
  method va_a_lugar(lugar) = self.preferencias().any({preferencia => preferencia.va_a_lugar(lugar)})
}

class Persona {
  var property preferencia
  var property presupuesto_maximo

  method va_de_vacaciones(lugar) = preferencia.va_a_lugar(lugar)
  method puede_pasar_lugares(tour) = tour.lugares().all({lugar => self.va_de_vacaciones(lugar)})
  method puede_ir_tour(tour) = self.puede_pasar_lugares(tour) && tour.monto_por_persona() <= presupuesto_maximo
}

class Tour {
  var property fecha_salida
  var property cantidad_personas_requerida
  var property cantidad_personas
  var property lugares
  var property monto_por_persona

  method confirmacion() = cantidad_personas == cantidad_personas_requerida
  method confirmacionPendiente() = !self.confirmacion()
  method agregar_persona(persona) {
	if(cantidad_personas < cantidad_personas_requerida && persona.puede_ir_tour(self)){
		cantidad_personas + 1
	}else{
		throw new UserException(message = "El tour ya se encuentra confirmado, para agregar una persona debe dar de baja otro pasajero") 
	}
  }
  method bajar_persona(persona) {
	if(cantidad_personas > 0){
		cantidad_personas - 1
	}else{
		throw new UserException(message = "El tour ya se encuentra vacio.") 
	}
  }
  method total_recaudado() = cantidad_personas * monto_por_persona
}

class UserException inherits Exception{}