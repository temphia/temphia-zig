create table system_events(
    id integer primary key autoincrement not null,
    type text not null,
    data text not null,
    extra_meta json not null default '{}',
    tenant_id text not null default ''
);
create table system_kv(
    id integer primary key autoincrement not null,
    key text not null,
    type text not null default '',
    value text not null default '',
    tenant_id text not null default '',
    unique(key, type, tenant_id)
);

create table domains(
    id integer primary key autoincrement not null,
    name text not null default '',
    about text not null default '',
    default_ugroup text not null default '',
    cors_policy text not null default '',
    adapter_policy text not null default '',
    adapter_metadata json not null default '{}',
    extra_meta json not null default '{}',
    unique(name, tenant_id)
);

create table target_apps(
    id integer primary key autoincrement not null,
    name text not null default '',
    target_type text not null,
    target text not null,
    context_type text not null default '',
    icon text not null default '',
    policy text not null default '',
    app_id text not null,
    entry_id text not null,
    bprint_id text not null default '',
    bprint_item_id text not null default '',
    bprint_instance_id text not null default '',
    bprint_step_head text not null default '',
    extra_meta json not null default '{}',
    exec_meta json not null default '{}',
    tenant_id text not null,
    unique(target_type, target, context_type, tenant_id)
);

create table target_hooks(
    id integer primary key autoincrement not null,
    name text not null default '',
    target_type text not null,
    target text not null,
    event_type text not null default '',
    policy text not null default '',
    app_id text not null default '',
    entry_id text not null default '',
    bprint_id text not null default '',
    bprint_item_id text not null default '',
    bprint_instance_id text not null default '',
    bprint_step_head text not null default '',
    extra_meta json not null default '{}',
    exec_meta json not null default '{}',
    tenant_id text not null,
    unique(target_type, target, event_type, tenant_id)
);

create table repos(
    id integer primary key autoincrement not null,
    name text not null default '',
    provider text not null default '',
    url text not null default '',
    extra_meta json not null default '{}',
    tenant_id text not null
);

create table user_groups(
    name text not null default '',
    slug text not null,
    scopes text not null default '',
    tenant_id text not null,
    features text not null default '',
    feature_opts json not null default '{}',
    extra_meta json not null default '{}',
    mod_version integer not null default 0,
    primary KEY(slug, tenant_id)
);

create table users(
    id integer primary key autoincrement not null,
    full_name text not null default '',
    bio text not null default '',
    password text not null default '',
    email text not null default '',
    tenant_id text not null,
    group_id text not null,
    email_verified boolean not null default TRUE,
    phone_verified boolean not null default TRUE,
    private_meta json not null default '{}',
    public_meta json not null default '{}',
    created_at timestamp not null default current_timestamp,
    active boolean not null default false,
    extra_meta json not null default '{}',
    foreign KEY(group_id, tenant_id) references user_groups(slug, tenant_id),
    unique(tenant_id, email),
    primary KEY(user_id, tenant_id)
);

create table user_devices(
    id bigint not null,
    name text not null default '',
    user_id text not null,
    device_type text not null default 'device',
    --- device/login
    apn_token text not null default '',
    scopes text not null default '',
    last_data json not null default '{}',
    -- browser/ip/timestamp
    expires_on timestamptz not null,
    pair_options json not null default '{}',
    extra_meta json not null default '{}',
    tenant_id text not null,
    foreign KEY(user_id, tenant_id) references users(user_id, tenant_id),
    primary key(id)
);

create table user_messages(
    id integer primary key autoincrement not null,
    title text not null default '',
    read boolean not null default false,
    type text not null,
    contents text not null,
    user_id text not null,
    from_user text not null default '',
    from_app text not null default '',
    from_entry text not null default '',
    app_callback text not null default '',
    warn_level integer not null default 0,
    -- tags text not null default '',
    encrypted boolean not null default false,
    created_at timestamptz not null default current_timestamp,
    tenant_id text null,
    foreign KEY(user_id, tenant_id) references users(user_id, tenant_id)
);

create table user_group_auths(
    id integer primary key autoincrement not null,
    name text not null default '',
    type text not null,
    provider text not null default '',
    provider_opts json default '{}',
    scopes text not null default '',
    policy text not null default '',
    user_group text not null,
    tenant_id text not null,
    extra_meta json default '{}',
    foreign KEY(user_group, tenant_id) references user_groups(slug, tenant_id)
);

create table user_group_datas(
    id integer primary key autoincrement not null,
    data_source text not null,
    data_group text not null,
    policy text not null default '',
    user_group text not null,
    tenant_id text not null,
    extra_meta json default '{}',
    foreign KEY(user_group, tenant_id) references user_groups(slug, tenant_id)
);
create table user_resources(
    id integer primary key autoincrement not null,
    data_source text not null,
    data_group text not null,
    policy text not null default '',
    user_group text not null,
    tenant_id text not null,
    extra_meta json default '{}',
    foreign KEY(user_group, tenant_id) references user_groups(slug, tenant_id)
);

create table app_states(
    key text not null,
    value text not null,
    version integer not null default 0,
    tag1 text not null default '',
    tag2 text not null default '',
    tag3 text not null default '',
    ttl timestamp,
    app_id text not null,
    tenant_id text not null,
    PRIMARY KEY(tenant_id, key, app_id)
);

create table bprints(
    id text not null,
    slug text not null default '',
    name text not null default '',
    type text not null,
    sub_type text not null default '',
    inline_schema text not null default '',
    description text not null default '',
    icon text not null default '',
    source_id text not null default '',
    files text not null default '',
    tags text not null default '',
    extra_meta json not null default '{}',
    tenant_id text not null,
    primary KEY(id, tenant_id)
);

create table apps(
    id text not null,
    name text not null default '',
    live boolean not null default false,
    dev boolean not null default false,
    bprint_id text not null default '',
    invoke_policy text not null default '',
    extra_meta json not null default '{}',
    tenant_id text not null,
    primary KEY(id, tenant_id)
);

create table entries(
    slug text not null,
    name text not null default '',
    type text not null,
    executor text not null,
    serve_meta json not null default '{}',
    entry_file text not null default '',
    extra_meta json not null default '{}',
    tenant_id text not null,
    app_id text not null,
    foreign KEY(app_id, tenant_id) references apps(id, tenant_id),
    primary KEY(id, app_id, tenant_id)
);

create table resources(
    id text not null,
    name text not null default '',
    type text not null,
    sub_type text not null default '',
    target text not null default '',
    policy text not null default '',
    extra_meta json not null default '{}',
    tenant_id text not null,
    primary KEY(id, tenant_id)
);

create table links(
    id integer primary key autoincrement not null,
    name text not null default '',
    from_app_id text not null,
    from_entry_id text not null,
    to_app_id text not null,
    to_entry_id text not null,
    to_handler text not null default '',
    tenant_id text not null,
    extra_meta json not null default '{}',

    foreign KEY(to_app_id, tenant_id) references apps(id, tenant_id),
    foreign KEY(to_entry_id, to_app_id, tenant_id) references entries(id, app_id, tenant_id),
    foreign KEY(from_app_id, tenant_id) references apps(id, tenant_id),
    foreign KEY(from_entry_id, from_app_id, tenant_id) references entries(id, app_id, tenant_id)
);

create table app_resources(
    slug text not null,
    app_id text not null,
    entry_id text not null,
    resource_id text not null,
    tenant_id text not null,
    actions text not null default '',
    policy text not null default '',
    foreign KEY(resource_id, tenant_id) references resources(id, tenant_id),
    foreign KEY(app_id, tenant_id) references apps(id, tenant_id),
    foreign KEY(entry_id, app_id, tenant_id) references entries(id, app_id, tenant_id),
    primary KEY(slug, app_id, entry_id, tenant_id)
);

create table app_extensions(
    id integer primary key autoincrement not null,
    name text not null default '',
    app_id text not null,
    entry_id text not null,
    brpint_id text not null,
    ref_file text not null,
    tenant_id text not null,
    extra_meta json not null default '{}',
    foreign KEY(app_id, tenant_id) references apps(id, tenant_id),
    foreign KEY(entry_id, app_id, tenant_id) references entries(id, app_id, tenant_id)
);