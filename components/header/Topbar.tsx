// third-party
import { FormattedMessage } from 'react-intl'

// application
import AppLink from '../shared/AppLink'
import Dropdown from './Dropdown'

export default function Topbar() {
  const links = [
    {
      title: <FormattedMessage id="topbar.aboutUs" defaultMessage="About Us" />,
      url: '/site/about-us',
    },
    {
      title: <FormattedMessage id="topbar.contacts" defaultMessage="Contacts" />,
      url: '/site/contact-us',
    },
    {
      title: <FormattedMessage id="topbar.storeLocation" defaultMessage="Store Location" />,
      url: '',
    },
    {
      title: <FormattedMessage id="topbar.trackOrder" defaultMessage="Track Order" />,
      url: '/shop/track-order',
    },
    {
      title: <FormattedMessage id="topbar.blog" defaultMessage="Blog" />,
      url: '/blog/category-classic',
    },
  ]

  const accountLinks = [
    { title: 'Dashboard', url: '/account/dashboard' },
    { title: 'Edit Profile', url: '/account/profile' },
    { title: 'Order History', url: '/account/orders' },
    { title: 'Addresses', url: '/account/addresses' },
    { title: 'Password', url: '/account/password' },
    { title: 'Logout', url: '/account/login' },
  ]

  const linksList = links.map((item, index) => (
    <div key={index} className="topbar__item topbar__item--link">
      <AppLink href={item.url} className="topbar-link">
        {item.title}
      </AppLink>
    </div>
  ))

  return (
    <div className="site-header__topbar topbar">
      <div className="topbar__container container">
        <div className="topbar__row">
          {linksList}
          <div className="topbar__spring" />
          <div className="topbar__item">
            <Dropdown
              title={<FormattedMessage id="topbar.myAccount" defaultMessage="My Account" />}
              items={accountLinks}
            />
          </div>
        </div>
      </div>
    </div>
  )
}
