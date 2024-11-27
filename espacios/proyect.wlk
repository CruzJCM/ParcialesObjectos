class Espacio {
  var property valuacion
  const property superficie
  const property nombre
  var tiene_vallado
  const property trabajos = []

  method supera_metros_base() = self.superficie() > 50
  method cumple_condicion_grande()
  method es_grande() = self.supera_metros_base() && self.cumple_condicion_grande()

  method poner_vallado() {
    tiene_vallado = true
  }
  method aumentar_valuacion(valor) {
    valuacion += valor
  }

  method es_verde() = false
  method es_limpiable() = false

  method agregar_trabajo(trabajo) {
    trabajos.add(trabajo)
  }
}

class Plaza inherits Espacio {
  var property cantidad_canchas

  override method cumple_condicion_grande() = cantidad_canchas > 2

  override method es_verde() = cantidad_canchas == 0
  override method es_limpiable() = true
}

class Plazoleta inherits Espacio {
  const property procer
  var property cierra_con_llave

  override method cumple_condicion_grande() = (procer == "San Martin" && cierra_con_llave)
}

class Anfiteatro inherits Espacio {
  var property capacidad
  var property tamanio_teatro

  override method cumple_condicion_grande() = capacidad > 500
  override method es_limpiable() = self.es_grande()
}

class Multiespacio inherits Espacio {
  const espacio = []

  override method cumple_condicion_grande() = espacio.all({espacio => espacio.cumple_condicion_grande()})

  override method es_verde() = espacio.length() > 3
}

class Profesional {
  var property nombre
  var property profesion
  var property es_jardinero
  var property espacio_de_trabajo 

  method costo_hora() = if (es_jardinero) 2500 else 100

  method validar() = if (profesion.puede_trabajar(espacio_de_trabajo)) true else throw new DomainException(message = "El profesional no cuenta con las aptitudes requeridas para realizar el trabajo")

  method realizar() {
    profesion.cumplir_trabajo(espacio_de_trabajo)
  }

  method gestionar() {
    const nuevo_trabajo = new Trabajo(
      autor = nombre,
      fecha = new Date(),
      duracion = profesion.duracion_trabajo(espacio_de_trabajo),
      costo = self.costo_hora()
    )
    espacio_de_trabajo.agregar_trabajo(nuevo_trabajo)
  }

  method registrar() {
    self.validar()
    self.realizar()
    self.gestionar()
  }
}

object cerrajero {
  method puede_trabajar(espacio) = !espacio.tiene_vallado()
  method cumplir_trabajo(espacio) {
    if (self.puede_trabajar(espacio)) {
        espacio.poner_vallado()
    }
  }
  method duracion_trabajo(espacio) = if (espacio.es_grande()) 5 else 3  
}

object jardinero {
  method puede_trabajar(espacio) = espacio.es_verde()
  method cumplir_trabajo(espacio) {
    if (self.puede_trabajar(espacio)) {
        espacio.aumentar_valuacion(espacio.valuacion() * 0.1)
    }
  }
  method duracion_trabajo(espacio) = espacio.superficie()/10
}

object encargado {
  method puede_trabajar(espacio) = espacio.es_limpiable()
  method cumplir_trabajo(espacio) {
    if (self.puede_trabajar(espacio)) {
        espacio.aumentar_valuacion(5000)
    }
  }
  method duracion_trabajo(espacio) = 8
}

/*
wollok:proyect> const tito = new Profesional(nombre="Tito",profesion=cerrajero)
✓
wollok:proyect> tito.profesion()
✓ cerrajero
wollok:proyect> tito.profesion(jardinero)
✓ 
wollok:proyect> tito.profesion()
✓ jardinero
*/

class Trabajo {
  var property autor
  var property fecha
  var property duracion
  var property costo    
}