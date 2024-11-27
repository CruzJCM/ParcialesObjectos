//-----------------------------------------------------------------------------------------------------------
class Guerrero {
  var property vida
  var property poder 
  var property tactica 
  const property armas = []

  method esta_muerto() = vida == 0
  method disminuir_vida(valor) {
    vida -= valor
  }
  method aumentar_vida(valor) {
    vida += valor
  }
  method alterar_vida(valor) {
    vida = valor
  }
  method arma_mayor_poder()
  method mejor_amigo() 
  method enemigo() 
}
//-----------------------------------------------------------------------------------------------------------
class Tactica {
  method danio_causado(guerrero) = guerrero.poder()
  method danio_recibido(contrincante) = contrincante.poder()

  method puede_combatir(guerrero,contrincante) = !guerrero.esta_muerto() && !contrincante.esta_muerto()

  method daniar(guerrero,contrincante) {
    contrincante.disminuir_vida(self.danio_causado(guerrero))
  }
  method resistir(guerrero,contrincante) {
    guerrero.disminuir_vida(self.danio_recibido(contrincante))
  }

  method efecto_de_ataque(guerrero,contrincante) {}
  method atacar(guerrero,contrincante) {
    if (self.puede_combatir(guerrero,contrincante)) self.efecto_de_ataque(guerrero,contrincante)
  }
}

object tacticaAgil inherits Tactica {
  override method danio_causado(guerrero) = guerrero.poder() + 100

  override method efecto_de_ataque(guerrero,contrincante) {
    self.daniar(guerrero,contrincante)
    self.resistir(guerrero,contrincante)
  }
}

object tacticaResistencia inherits Tactica{
  override method danio_recibido(contrincante) = contrincante.poder() / 2

  override method efecto_de_ataque(guerrero,contrincante) {
    self.resistir(guerrero,contrincante)
    self.daniar(guerrero,contrincante)
  }
}

class TacticaCaruso inherits Tactica {
  var property umbral

  method supera_umbral(contrincante) = contrincante.poder() > umbral
  method huir(guerrero) {
    guerrero.disminuir_vida(10)
  }

  override method efecto_de_ataque(guerrero,contrincante) {
    if (!self.supera_umbral(contrincante)) {
      self.daniar(guerrero,contrincante)
      self.resistir(guerrero,contrincante)
    }else {
      self.huir(guerrero)
    }
  }
}

object tacticaCuatroTresTres inherits Tactica {
  method evita_ataque(guerrero) = guerrero.vida() > 60
  method intenta_evitar_ataque(guerrero,contrincante) {
    if (!self.evita_ataque(guerrero)) self.resistir(guerrero,contrincante)
  }

  override method efecto_de_ataque(guerrero,contrincante) {
    self.daniar(guerrero,contrincante)
    self.daniar(guerrero,contrincante)
    self.intenta_evitar_ataque(guerrero,contrincante)
  }
}
//-----------------------------------------------------------------------------------------------------------
object penalidadTotalVida {
  method aplicar_penalidad(guerrero) {
    guerrero.disminuir_vida(guerrero.vida())
  }
}
class PenalidadFraccionVida {
  var property fraccion 
  method calcular_fraccion(guerrero) = guerrero.vida() * fraccion / 100 
  method aplicar_penalidad(guerrero) {
    guerrero.disminuir_vida(self.calcular_fraccion(guerrero))
  }
}
object quitarArmaMayorPoder {
  method aplicar_penalidad(guerrero) {
    guerrero.armas().remove(guerrero.arma_mayor_poder())
  }
}

class PenalidadMultiple{
  const property penalidades = []

  method agregar_penalidad(penalidad) {
    penalidades.add(penalidad)
  }
  method aplicarPenalidad(guerrero) {
    penalidades.forEach({penalidad => penalidad.aplicar_penalidad(guerrero)})
  }
}
//-----------------------------------------------------------------------------------------------------------
class Anillo{
  const property duenio

  method duplicar_vida() = 100.min(duenio.vida() * 2)
  method concecuencias() {}
  method ser_invocado() {
    duenio.alterar_vida(self.duplicar_vida())
    self.concecuencias()
  }
}

class AnilloFuego inherits Anillo{
  override method concecuencias() {
    duenio.tactica().atacar(self, duenio.enemigo())
    duenio.enemigo().disminuir_vida(20)
  }
}
class AnilloMaldito inherits Anillo{
  override method concecuencias() {
    duenio.armas().remove(duenio.arma_mayor_poder())
  }
}
class AnilloAire inherits Anillo{
  override method concecuencias() {
    duenio.mejor_amigo().aumentar_vida(30)
  }
}
object anilloUnico inherits Anillo(duenio = "gollum"){
  method efecto() {
    if (duenio.armas().length() > 3) duenio.disminuir_vida(20) else duenio.disminuir_vida(30)
  }
  override method concecuencias() {
    if (duenio.esta_muerto()) !duenio.esta_muerto()
  }
}
//-----------------------------------------------------------------------------------------------------------