# This file is part of the Open AS Communication Gateway.
#
# The Open AS Communication Gateway is free software: you can redistribute it
# and/or modify it under theterms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# The Open AS Communication Gateway is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
# General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along
# with the Open AS Communication Gateway. If not, see http://www.gnu.org/licenses/.


package Underground8::Service::MySQL::SLAVE;
use base Underground8::Service::SLAVE;

use strict;
use warnings;
use Error;
use Underground8::Utils;
use Underground8::Exception;
use Underground8::Exception::FileOpen;
use Template;
use Data::Dumper;


sub new ($)
{
    my $class = shift;
    my $self = $class->SUPER::new('mysql');
    return $self;
}

sub service_stop($)
{
    my $self = instance(shift);
    print STDERR "\n\n\nMySQL STOP called\n\n\n";
    
    my $output = safe_system($g->{'cmd_mysql_stop'});
}

sub service_start($)
{
    my $self = instance(shift);
    print STDERR "\n\n\nMySQL START called\n\n\n";
    
    my $output = safe_system($g->{'cmd_mysql_start'});
}

sub service_restart($)
{
    my $self = instance(shift);
    print STDERR "\n\n\nMySQL RESTART called\n\n\n";
    
    my $output = safe_system($g->{'cmd_mysql_restart'});
}


sub write_config($$)
{
    my $self = instance(shift);
   
    my $memory_factor = $self->memory_factor;
 
    my $template = Template->new (
	{
	    INCLUDE_PATH => $g->{'cfg_template_dir'},
	});  
    
    my $options = {
	    info => 'autogenerated by LimesAS',
        memory_factor => $memory_factor,
    };
    
    my $config_content;
    $template->process($g->{'template_mysql'},$options,\$config_content) 
        or throw Underground8::Exception($template->error);

    open (MYSQLCONF,'>',$g->{'file_mysql'})
        or throw Underground8::Exception::FileOpen($g->{'file_mysql'});

    print MYSQLCONF $config_content;

    close (MYSQLCONF);
}



1;
