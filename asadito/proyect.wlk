class Comensal {
  const property elementos
  var property posicion
  var property criterio 

  method pedir_elemento(comensal,elemento) {
    if (!comensal.elementos().contains(elemento)){
      throw new DomainException(message = "El comensal no tiene el elemento solicitado")
    }
    comensal.dar_elemento(elemento)
  }
  method dar_elemento(comensal,elemento) {}
  method cambiar_posicion(nueva) {
    self.posicion(nueva)
  }
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


