class Comensal {
  const property elementos
  var property posicion
  var property criterio_elementos
  const property comidas
  var property criterio_comidas 

  method pedir_elemento(emisor,elemento) {
    if (!emisor.elementos().contains(elemento)){
      throw new DomainException(message = "El comensal no tiene el elemento solicitado")
    }
    criterio_elementos.dar_elemento(emisor,self,elemento)
  }
  method cambiar_posicion(nueva) {
    self.posicion(nueva)
  }

  method comer_de_bandeja(comida) {
    if (criterio_comidas.come(comida)) comidas.add(comida) else throw new DomainException(message = "La comida no es de la preferencia del comensal")
  }

  method es_pipon() = comidas.any({comida => comida.es_pesada()})
}

object sordera {
  method primer_elemento(emisor) = emisor.elementos().first()
  method dar_elemento(emisor,receptor,elemento) {
    receptor.elementos().add(self.primer_elemento(emisor))
    emisor.elementos().remove(self.primer_elemento(emisor))
  }
}
object suceptible {
  method dar_elemento(emisor,receptor,elemento) {
    receptor.elementos().addAll(emisor.elementos())
    emisor.elementos().clear()
  }
}
object inquietud {
  method dar_elemento(emisor,receptor,elemento) {
    receptor.cambiar_posicion(emisor.posicion())
    emisor.cambiar_posicion(receptor.posicion())
  }
}
object bendito {
  method dar_elemento(emisor,receptor,elemento){
    receptor.elementos().add(elemento)
    emisor.elementos().remove(elemento)
  }
}


class Comida {
  const property bandeja
  const property es_carne
  const property calorias
  
  method es_pesada() = self.calorias() > 500 
}

object vegetariano {
  method come(comida) = !comida.es_carne()
}
object dietetico {
  var property recomendacion_oms = 500
  method come(comida) = comida.calorias() < recomendacion_oms
}
class Combineta {
  const property preferencias
  method come(comida) = preferencias.any({preferencia => preferencia.come(comida)})
}

