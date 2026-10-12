<?php

/**
 * Renames the "Get support" link (support_url) to point users at the
 * mail client setup page.
 */
class setup_link extends rcube_plugin
{
    public function init()
    {
        $this->add_hook('startup', [$this, 'startup']);
    }

    public function startup($args)
    {
        rcmail::get_instance()->load_language(null, [], [
            'support' => 'Configure other email clients',
        ]);

        return $args;
    }
}
