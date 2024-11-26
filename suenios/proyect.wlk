class Persona {
  const suenios = []
  var property felicidad
  var carreras_deseadas = []
  var carreras_completadas = []
  var cantidadHijos = 0
  const lugares_visitados = []
  var property salario_desado
  var property salario 
  var criterio
  var suenio_mas_importante = criterio.elegir_suenio(self.suenios_pendientes())

  method aumentar_felicidad(valor) {
    felicidad += valor
  }
  method disminuir_felicidad(valor) {
    felicidad -= valor
  }

  method suenios_pendientes() = suenios.filter { suenio => suenio.estaPendiente() }
  method cumplir_suenio(suenio) {
	if (!self.suenios_pendientes().contains(suenio)) {
        throw new DomainException(message = "El sueño " + suenio + " no está pendiente")
	}else
		suenio.cumplir(self)
  }

  method suenia_estudiar(carrera) = carreras_deseadas.contains(carrera)
  method completo_carrera(carrera) = carreras_completadas.contains(carrera)
  
  method completar_carrera(carrera) {
    carreras_completadas.add(carrera)
  }

  method tieneHijos() = cantidadHijos > 0
  
  method agregar_hijos(cantidad) {
    cantidadHijos += cantidad
  }

  method viajar_a(lugar) {
	lugares_visitados.add(lugar)
  }

  method cumplirSuenioElegido() {
	self.cumplir_suenio(suenio_mas_importante)
  }

  method es_feliz() = felicidad > self.suenios_pendientes().sum({suenio => suenio.felicidad_otorgada()})

  method esAmbiciosa() = self.suenios_ambiciosos().size() > 3
  method suenios_ambiciosos() = suenios.filter { suenio => suenio.esAmbicioso() }
}

class Suenio {
	var cumplido = false
    var property felicidad_otorgada = 100

    method felicidad_total() = felicidad_otorgada

	method estaPendiente() = !cumplido

    method cumplimentar() {
        cumplido = true
    }

    method cumplir(persona) {
		self.validar(persona)
		self.realizar(persona)
		self.cumplimentar()
		persona.aumentar_felicidad(felicidad_otorgada)
	}
    method validar(persona) {}
    method realizar(persona) {}

    method esAmbicioso() = self.felicidad_total() > 100
}

class Recibirse inherits Suenio{
  var property carrera

  override method validar(persona) {
    if (!persona.suenia_estudiar(carrera)) {
		throw new DomainException(message = persona.toString() + " no quiere estudiar " + carrera)
	}
	if (persona.completo_carrera(carrera)) {
		throw new DomainException(message = persona.toString() + " ya completó los estudios de " + carrera)
	}
  }

  override method realizar(persona) {
		persona.completar_carrera(carrera)
  }
}

class AdoptarHijo inherits Suenio {
  var property cantidad_hijos_adoptados

  override method validar(persona) {
    if (persona.tieneHijos()) {
		throw new DomainException(message = "No se puede adoptar si se tiene un hijo")
	}
  }

  override method realizar(persona) {
	persona.agregar_hijos(cantidad_hijos_adoptados)
  }
}

class Viajar inherits Suenio {
  var property lugar

  override method realizar(persona) {
	persona.viajar_a(lugar)
  }
}

class ConseguirTrabajo inherits Suenio {
  const ganancia

  override method validar(persona) {
    if (persona.salario_desado() > ganancia) {
		throw new DomainException(message = persona.toString() + " quiere ganar mas plata")
	}
  }

  override method realizar(persona) {
	persona.salario_desado(ganancia)
  }
}

class SuenioMultiple inherits Suenio{
  const suenios = []

  override method felicidad_total() = suenios.sum { suenio => suenio.felicidad_otorgada()}

  override method validar(persona) {
    suenios.forEach { suenio => suenio.validar(persona)}
  }
  override method realizar(persona) {
	suenios.forEach { suenio => suenio.realizar(persona)}
  }
}

const suenio = new SuenioMultiple(suenios = [new Viajar(lugar = "Cataratas"), new AdoptarHijo(cantidad_hijos_adoptados = 1), new ConseguirTrabajo(ganancia = 10000)])


object realista { // strategy stateless
	method elegir_suenio(suenios_pendientes) {
		suenios_pendientes.max { suenio => suenio.felicidad_total() }
	}
}
object alocado { // strategy stateless
	method elegir_suenio(suenios_pendientes) {
		suenios_pendientes.anyOne()
	}
}
object obsesivo { // strategy stateless
	method elegir_suenio(suenios_pendientes) {
		suenios_pendientes.first()
	}
}