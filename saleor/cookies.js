const CART_TOKEN_COOKIE = 'cart_token'

export const readCartTokenCookie = req => {
  return req.cookies[CART_TOKEN_COOKIE]
}

export const deleteCartTokenCookie = (req, res) => {
  res.setHeader('Set-Cookie', 'cart_token=deleted; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT')
}
