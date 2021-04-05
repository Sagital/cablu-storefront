import Typography from '@material-ui/core/Typography'
import regions from './regions'

export default function AddressCard({ address }) {
  return (
    <>
      <Typography>{address.firstName + ' ' + address.lastName + ' - ' + address.phone}</Typography>
      <Typography>
        {address.streetAddress + ', ' + address.locality + ', ' + regions[address.region]}
      </Typography>
    </>
  )
}
