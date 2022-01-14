module ApplicationHelper
  def default_meta_tags
    defaults = t('meta_tags.defaults')
    site = defaults[:site]
    description = defaults[:description]
    keywords = defaults[:keywords]
    title = defaults[:title]

    {
      site: site,
      reverse: true,
      charset: 'utf-8',
      description: description,
      keywords: keywords,
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon.ico') }
      ],
      og: {
        site_name: site,
        description: description,
        type: 'website',
        url: request.original_url,
        image: image_url('account_share.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@Nmittyancccccc',
        title: title,
        image: image_url('twitter_card.png')
      }
    }
  end
end
