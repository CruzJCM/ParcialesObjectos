class Comensal {
  const property elementos = []
  var property posicion = 0
  var property criterio_elementos = sordera
  const property comidas = []
  var property criterio_comidas = vegetariano

  method tiene_elemento(elemento) = self.elementos().contains(elemento)
  method pasar_elemento(receptor,elemento) {
    if (!self.tiene_elemento(elemento)){
      throw new DomainException(message = "No tengo cerca el elemento" + elemento)
    }
    criterio_elementos.dar_elemento(self,receptor,elemento)
  }
  method cambiar_posicion(nueva) {
    self.posicion(nueva)
  }

  method comer_de_bandeja(comida) {
    if (criterio_comidas.come(comida)) comidas.add(comida) else throw new DomainException(message = "La comida no es de la preferencia del comensal")
  }

  method es_pipon() = comidas.any({comida => comida.es_pesada()})
  
  method comio_algo() = !comidas.isEmpty()
  method cumple_condicion_pasarla_bien() 
  method la_pasa_bien() = self.comio_algo() && self.cumple_condicion_pasarla_bien()
}


//Ejemplo claro de polimorfismo con el method "dar_elemento" que ni siquiera es heredado por todos, y para cada uno realiza una cosa distinta, pero todos los objetos entienden el mismo mensaje. Este strategy permite utilizar estos objetos que solo tienen un objetivo. Con esto delgo responsabildiades de manera eficiente y aumento la cohesividad del codigo.
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
class Alternado {
  var acepta = false
  method come(comida) {
    acepta = !acepta
	return not acepta
  } 
}
//Aca realizo una composicion, de esta manera mejoro la interaccion del comensal de modo que no tenga que usar listas. Esto me permite cambiar facilmente el criterio de los comensales para las comidas, lo que esta explicito en el enunciado.
class Combineta {
  const property preferencias = []
  //se podria agragar un method para agragar criterios: method agregarCriterios(criterios) = criteriosDeAceptacion.addAll(criterios)
  method come(comida) = preferencias.all({preferencia => preferencia.come(comida)})
}


//Todas estos objetos heredan el comportamiento del comensal, de esta manera utilizando un template method se puede diferenciar de manera sencilla el comportamiento de "pasarla bien" para cada uno de ellos.
object osky inherits Comensal {
  override method cumple_condicion_pasarla_bien() = true
}
object moni inherits Comensal {
  override method cumple_condicion_pasarla_bien() = posicion == "1@1" //esto no lo vimos
}
object facu inherits Comensal {
  override method cumple_condicion_pasarla_bien() = comidas.any({comida => comida.es_carne()})
}
object vero inherits Comensal {
  override method cumple_condicion_pasarla_bien() = elementos.length() > 3
}