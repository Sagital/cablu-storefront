import localities from './localities.json'

export default function handler(req, res) {
  res.status(200).json(localities[req.query.region])
}
