import express from 'express'
import mongoose from 'mongoose'

const Animal = mongoose.model('Animal', new mongoose.Schema({
  tipo: String,
  estado: String,
}))

const app = express()

mongoose.connect('mongodb://dani:password@monguito:27017/miapp?authSource=admin')

app.get('/', async (_req, res) => {
  console.log('listando...')
  const animales = await Animal.find();
  return res.send(animales)
})
app.get('/crear', async (_req, res) => {
  console.log('creando...')
  await Animal.create({ tipo: 'Gato', estado: 'Feliz' })
  return res.send('Prueba')
})
app.get('/actualizar', async (_req, res) => {
  console.log('actualizando...')
  await Animal.updateOne({ tipo: 'Gato' }, { estado: 'Triste' })
  return res.send('Objeto Actualizado')
})

app.listen(3000, () => console.log('listening...'))