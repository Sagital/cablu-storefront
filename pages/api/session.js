export default async function(req, res) {
  return res.json({
    name: 'Mark',
    email: 'mark@domain.com',
    itemsInCart: 3,
    currency: 'USD',
  })
}
